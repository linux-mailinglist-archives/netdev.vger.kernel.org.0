Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91049D901
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfHZWYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:24:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39277 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfHZWYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:24:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so218352qki.6
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 15:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dlyhSOCkHAudwsfBjcA2mMYi1s6PT3X1umW2HLoZhfk=;
        b=St57i0a2AbrZAqnu4sxQ1Udl8+17EclRt+PZjoubrqbtqBHkrmTOYTJJhcz3QEtxPv
         oIN1Z7kFKopEfdrEH49bOknsaT6e9GUJah21HlMRJp3BPe1M4cXLAmT5RYrPSsLLYTDM
         jDQ/wzUmhiDbZsqbgokLfufti5CHtReR6rgdcLChrMa8yAxMWUFXOe4VPyLNwyA5YJzP
         /Hw83jk1bNrO0wR1r4EtmTH/ps+hItDJ4u7LNgnARwshrt2vMpotDPCILrRriKvOklvZ
         x8z++O9B1JPsCU9GDK8xDoDIqUPEyq2GkRBn2maakeUSeMOvX/OoxN5q0OnpLteh0rlH
         jjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dlyhSOCkHAudwsfBjcA2mMYi1s6PT3X1umW2HLoZhfk=;
        b=D8Inff8OHZA3q/MceL5947ObCX8GkdLqS8FaKdmCfK/bVk5YUQKVPyLeCHFFS0h6Ka
         ppS9BVnmK2+jVDNcpD+B4sxVeOEBcERhDGcZIHZELnB4EYrybr9JfPPTSpK2s8biRXMJ
         6tSmo+7+jL3kYSf/EpS5ns72YbkCkeNIlb6MLJv0u2ddo2uHoy5NU6+q49msfdwpBbbd
         fh+mWEW157W7UKGcaBaYAGhDvaPlVwNn/qIHsQAZ9ZJNcQ1VhNKAG6/LVyZ6c7Fr2wH8
         Wt+NQcTimbsJH9m0vm0y8UsojGCOgPaHDY1qQLCRSKNECzblLPwYDILv9H+EHA2c1qnd
         wY7Q==
X-Gm-Message-State: APjAAAUvniPxWyfmx54J0MVsPt2yE3uvAZi5xu5U1wouPqPS5Q68EF8R
        j8CJY3EFjpFtWxC7gStuTvk=
X-Google-Smtp-Source: APXvYqzzL/N58mNMEKFQbbp6ryx5sxcXBzbuzm3oW36PvZt4E7Vs24mHIzQnJf/CnnP0kLmT1FG2MA==
X-Received: by 2002:ae9:f301:: with SMTP id p1mr19168208qkg.353.1566858281544;
        Mon, 26 Aug 2019 15:24:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id j18sm6739462qth.24.2019.08.26.15.24.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 15:24:40 -0700 (PDT)
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     David Miller <davem@davemloft.net>, jakub.kicinski@netronome.com
Cc:     jiri@resnulli.us, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, sthemmin@microsoft.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
References: <20190826095548.4d4843fe@cakuba.netronome.com>
 <5d79fba4-f82e-97a7-7846-fd1de089a95b@gmail.com>
 <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ddd05712-e8c7-3c08-11c7-9840f5b64226@gmail.com>
Date:   Mon, 26 Aug 2019 16:24:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826.151819.804077961408964282.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/19 4:18 PM, David Miller wrote:
> I honestly think that the size of link dumps are out of hand as-is.

so you are suggesting new alternate names should not appear in kernel
generated RTM_NEWLINK messages - be it a link dump or a notification on
a change?
