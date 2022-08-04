Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7CC58986A
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 09:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238992AbiHDHem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 03:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiHDHel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 03:34:41 -0400
Received: from smtp100.iad3a.emailsrvr.com (smtp100.iad3a.emailsrvr.com [173.203.187.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE9E2250C
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 00:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1659598480;
        bh=6MkCE36l5WmIlKxJd6FTnhAZba3Gf9HVJF7Z8CAabyk=;
        h=Date:Subject:To:From:From;
        b=am7wThGyBp/w714JNf2eRHLCrx7a/iBo2ChidVMunCHVGQtY2H3xgLF8mvHT2ztvq
         7T6Ub/sTdP2BIIzs8jPEWEARC30AVdR5m2QlBrPlM+jAUNdnMVOejtlTcZ3eXtqaJr
         CxhvHgVPHmlUgjkosbNUCpSEP7sY0qeIvgLa7tDI=
X-Auth-ID: antonio@openvpn.net
Received: by smtp13.relay.iad3a.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id C47C818C0;
        Thu,  4 Aug 2022 03:34:39 -0400 (EDT)
Message-ID: <05642e8f-6415-fdf0-0755-1617849ebef8@openvpn.net>
Date:   Thu, 4 Aug 2022 09:35:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20220719014704.21346-1-antonio@openvpn.net>
 <20220719014704.21346-2-antonio@openvpn.net>
 <04c967669e4ed8845323f1487fff86949f07a81d.camel@perches.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
In-Reply-To: <04c967669e4ed8845323f1487fff86949f07a81d.camel@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 102a1ffd-6bcb-4da1-93a1-a1ab38b255ec-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Joe,

On 03/08/2022 18:04, Joe Perches wrote:
> Please add
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 

Thanks for your suggestion! Will take care of this.

Regards,

-- 
Antonio Quartulli
OpenVPN Inc.
