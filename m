Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07662209851
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389136AbgFYBuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYBuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:50:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752E7C061573;
        Wed, 24 Jun 2020 18:50:53 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g20so2708079edm.4;
        Wed, 24 Jun 2020 18:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieM21daG8iLH5m3Mv7C6HY+EHtptloOkktpfceYfJjg=;
        b=IfvafsmFQmJinwkiAlheF0HQ5oBSVaSi8xj0u5esZhSm++gTQUJlm2GQGnu9l0DKn3
         wLBn+7n63//9mp/57JVydtIBsIJUogigQoFvnsG3MOTLwneqtFhpjT9LBzQ9jv5nov2G
         /szbKjNSFCW17GABvM/2Vviww5PW6cWA5vPNAsZq9VP9ci1a/qG7iWGD2tLGuwYq+dSX
         evvcEjpuNGkI8+MKSdOUGgftex4ehmx2ulnG0M2QqHGXiSowIm4j5QXyx1IteBSrTFD+
         Jv+FBtsEGwmDNU0A1T0Je+gt3yhS8STILbJzd4j+jLX2QwWs8q0atyIOnw2kGuYuvxso
         xT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieM21daG8iLH5m3Mv7C6HY+EHtptloOkktpfceYfJjg=;
        b=JhOP9BQKs7c8rbRjBW/ZItV3Otbe6kqooKu2QdJFgfaXnKUTDE5GyxxG8CtXNon0mJ
         2akcrSycmPhN/Cjy22fB/c9MgB22pVxDTt00r6tDg2iYISsgb2U5xaO/fbuqmDCc+N4Y
         yNhV0lX6/oPoBhtskWNB1/ZGuYlhdffj2KnDmH9h+c4aOacn+Rr7kK1cbuQ5Z4vObpaQ
         1LhCcWqvgjNnb6jNhHT0vV9e1+yf1MnHKohUzRMj4q9gMZjNYi6pvR0PcR9CxRe4Y/DY
         PXL6zNpxJTXjdencIY5D8pQIswnWJRaCes/a2XmHGSXmuk802Z+0qXeBgWNxf+00esdl
         JZaQ==
X-Gm-Message-State: AOAM531A470QUqZ9WV/Fc/P5sS0/9DdBzBDjKtlnrlMLoDwudBUD75XF
        sWMXPwrPL36bv2lKQjJX6te2Lutg
X-Google-Smtp-Source: ABdhPJxZtqlvvYvF1pOUwXtL5JwhD7Fqp8oOjjdgDhd1EByXQfuPJtnyrD0r0kqa6f2zyjsRgYEwbQ==
X-Received: by 2002:a05:6402:3047:: with SMTP id bu7mr10242131edb.287.1593049851823;
        Wed, 24 Jun 2020 18:50:51 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s14sm8638760edq.36.2020.06.24.18.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:50:51 -0700 (PDT)
Subject: Re: [PATCH net 2/3] net: bcmgenet: use __be16 for htons(ETH_P_IP)
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
 <1593047695-45803-3-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <32dde63e-95e1-bf1a-cf6e-2c930ae9471f@gmail.com>
Date:   Wed, 24 Jun 2020 18:50:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1593047695-45803-3-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 6:14 PM, Doug Berger wrote:
> The 16-bit value that holds a short in network byte order should
> be declared as a restricted big endian type to allow type checks
> to succeed during assignment.
> 
> Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
