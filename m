Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123A54E95D5
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241811AbiC1L4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242046AbiC1Lz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:55:59 -0400
Received: from stuerz.xyz (stuerz.xyz [IPv6:2001:19f0:5:15da:5400:3ff:fecc:7379])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BBA3587B;
        Mon, 28 Mar 2022 04:51:50 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id DB5E3FA6D6; Mon, 28 Mar 2022 11:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648468308; bh=3Wi+uKVZkL99swRaVau3EJ8BXQXDlu9JC1kflQpPOrg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oUQch5AaF2NS4T0Fc7buc7qaKcaMKVG810YRJRo241bkl85duCMxS23fDm3GVMDw1
         xL8wfFwfguE7DE2l/k4vVmJ5m+zw1ufGo67LfJIKzisY6pcfbZGcdaFk0B9ghPqfKS
         I2W7g/SOQV7recVh3ztaUhpWJY1H9k0XjfmxF8AmYZ/fAW3ggk2byys8WeLu0ak9ah
         IgL+/CAYYREpGVUMMRCs+UZIGRhzVjykJ9daQ0sVnnmKwNo2ovBFc7vsiaUCV/jRSa
         ex0Ku60KERB06l+p4AJhX5EDQm9DgjMeTcaApMq8icB704ISrupDr4D5KxV4dtLzM0
         6HAU3bjLTErUA==
Received: from [IPV6:2a02:8109:a100:1a48::e7c] (unknown [IPv6:2a02:8109:a100:1a48::e7c])
        by stuerz.xyz (Postfix) with ESMTPSA id 96ED2FA6AC;
        Mon, 28 Mar 2022 11:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648468306; bh=3Wi+uKVZkL99swRaVau3EJ8BXQXDlu9JC1kflQpPOrg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=zBafXC0qmHbBy2R0CwrqEVHxB0KbRcM6x7IR+QfcMB3oUVBkemOuTu17YEp7Cwbgd
         Lw+gvLver4LCPJCOHCL2eAzpr1O+pT/EX986F+oA22O2GOoGJb/57oYXvhAOACQpb/
         rN+svuiDvsbTolC94H1JtxdXdx0U3+g4ZYZxI9bHa94d/+r+oRSAJqz7+XAzj1cCh3
         ict551S0UMWEtEMaDv06/XFQYnv7JqCdIWuWPwV30h6+Z5RIA9IJAECe2MRFrynB4K
         mSzFCFSElIq/pRqE39gIg1HoMMEgNA6qMLNrZGciYbRFSH0ycDjGpa+qscnhjrtqTE
         wSGn8LEPrkJpQ==
Message-ID: <cc104272-d79a-41e1-f4de-cb78fb073991@stuerz.xyz>
Date:   Mon, 28 Mar 2022 13:51:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 00/22] Replace comments with C99 initializers
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <8f9271b6-0381-70a9-f0c2-595b2235866a@stuerz.xyz> <87fsn2zaix.fsf@kernel.org>
From:   =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
In-Reply-To: <87fsn2zaix.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        NICE_REPLY_A,PDS_OTHER_BAD_TLD,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.22 11:33, Kalle Valo wrote:
> Benjamin Stürz <benni@stuerz.xyz> writes:
> 
>> This patch series replaces comments with C99's designated initializers
>> in a few places. It also adds some enum initializers. This is my first
>> time contributing to the Linux kernel, therefore I'm probably doing a
>> lot of things the wrong way. I'm sorry for that.
> 
> Just a small tip: If you are new, start with something small and learn
> from that. Don't do a controversial big patchset spanning multiple
> subsystems, that's the hard way to learn things. First submit one patch
> at a time to one subsystem and gain understanding of the process that
> way.
> 

I actually thought this would be such simple thing. Do you know of any
good thing where to start? I already looked into drivers/staging/*/TODO
and didn't found something for me personally.

Should I drop this patchset and start with something different? If yes,
what would the proper way to drop it? Just announcing, that this is
going nowhere in a separate patch?
