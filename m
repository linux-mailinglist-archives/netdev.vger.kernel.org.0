Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9972263A01
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfGIROE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:14:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34434 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIROE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:14:04 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so44883366iot.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 10:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wg7cT1V74lHyVINm1PuMVNEkdvpIbynfWbAkCp7q2KM=;
        b=nxA+/BEPp73R0zV9QYjGM10azerww6EwmvbHTdgLV6OS8SmYhB7IXOQ4OgcX55Bhth
         IbKyIiIGfhdzyFoinbCeISrYifLpFQJBxVTRqIJSEW9Gz3CciWPISBmyxpHoPDRrE7/y
         vbSWYqcRZr2poiYWGChgrbKsARmkwuEECN3O6Kot5d6+0oGvH+TE4s2n7YOFRZxcilUk
         LCwCeZCS3wXRlf1/M5cL0UeaFkVco2CF9M7Q7ESx6rAEsRSJmwH32ZOtP1VoQM1lTzLS
         qr01tcFRecWx+Vwdl42PqCO7PHknDtLi2szqUsauQXEPknzfdAnWiN6uUI0oraeWDrEm
         oNOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wg7cT1V74lHyVINm1PuMVNEkdvpIbynfWbAkCp7q2KM=;
        b=rZVPgVFRp6uCC1+iEOqR5ip/kxY+3cEH+TYvWo4FlHugXKYesFk+o58vN7Ubhptihs
         RDjsaSgUMMUoG383wPsINiA6BVAXjLAjxEBfK086YmMgHmprAov9X/h5aJZedyYiBgKv
         VEujyHTpIKOTbxLA156JnmTjIfltqtR4tyYppU/9WCN7IPpeaLKea+shd2sbQUK38E0e
         M9bJynqZbKK903QOIibEk7gmXdU5zcVTbiMUXCBYWUfUOAMTM3RhKmKTb30io2A8qMY6
         /kqHbHtc9bIdYGK39wLel2kT3Nf2OU/Npa44jvAYeE9SAAQgU6U//oovyY/+CV8VgaVo
         rUKA==
X-Gm-Message-State: APjAAAU/T8Qev6Bql5wlvHCtuLUL89/8CBkQ2Jt6bIODE9+JacNqYAZm
        H3qjrLLyV85Os5G/mEQ+voW3vQAkJos=
X-Google-Smtp-Source: APXvYqyt0Ypji0unECaq4oMPZOc/ttCxmcE8QyahOwBKniLOHkq4pe7L4a6QvNv5XXNvGICPwffCrQ==
X-Received: by 2002:a5d:948a:: with SMTP id v10mr26877783ioj.103.1562692442230;
        Tue, 09 Jul 2019 10:14:02 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:c0e1:11bc:b0c5:7f? ([2601:282:800:fd80:c0e1:11bc:b0c5:7f])
        by smtp.googlemail.com with ESMTPSA id 8sm13577564ion.26.2019.07.09.10.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 10:14:01 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/2] Revert "ip6tunnel: fix 'ip -6 {show|change}
 dev <name>' cmds"
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <cover.1562667648.git.aclaudi@redhat.com>
 <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2460e246-5032-7804-fbc7-e689cebb4abe@gmail.com>
Date:   Tue, 9 Jul 2019 11:14:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/19 7:16 AM, Andrea Claudi wrote:
> This reverts commit ba126dcad20e6d0e472586541d78bdd1ac4f1123.
> It breaks tunnel creation when using 'dev' parameter:
> 
> $ ip link add type dummy
> $ ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2 local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev dummy0
> add tunnel "ip6tnl0" failed: File exists
> 
> dev parameter must be used to specify the device to which
> the tunnel is binded, and not the tunnel itself.
> 

Stephen: since this reverts a commit in 5.2 it should be in 5.2 as well.
