Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF159BBFF
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiHVIuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiHVIun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:50:43 -0400
X-Greylist: delayed 538 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Aug 2022 01:50:41 PDT
Received: from pmg.interduo.pl (pmg.interduo.pl [46.151.191.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D192CDF8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:50:41 -0700 (PDT)
Received: from pmg.interduo.pl (localhost [127.0.0.1])
        by pmg.interduo.pl (Proxmox) with ESMTP id 52A8F1D69F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:41:41 +0200 (CEST)
Received: from poczta.interduo.pl (poczta.interduo.pl [46.151.191.149])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pmg.interduo.pl (Proxmox) with ESMTPS id 2D85E1D69E
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:41:41 +0200 (CEST)
Received: from poczta.interduo.pl (localhost [127.0.0.1])
        by poczta.interduo.pl (Postfix) with ESMTP id 0459CE552A
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:41:41 +0200 (CEST)
Authentication-Results: poczta.interduo.pl (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=interduo.pl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=interduo.pl; h=
        content-transfer-encoding:content-type:content-type:subject
        :subject:from:from:content-language:to:user-agent:mime-version
        :date:date:message-id; s=dkim; t=1661157700; x=1662021701; bh=4N
        7r9dS38A8y6aNhPQ9Y+gluLeIY6XRDae/WAK10Uy4=; b=sVoAT40D0M65SDHfnc
        kvQi4WVKkjsodikBSJ6m3ctapuE5umMLFAln9+nbvs1EKiCCqlygE2FVwaJmcH3K
        xLJp3L7k1Q/cedkwbuRN+yybixp01txb1BEVgBSHf28RQOvTio8ht22q25xDnfoG
        f/46JnjcGnwc2mpb0f0sjMRck=
Received: from poczta.interduo.pl ([127.0.0.1])
        by poczta.interduo.pl (poczta.interduo.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ThWv5jTQbDGj for <netdev@vger.kernel.org>;
        Mon, 22 Aug 2022 10:41:40 +0200 (CEST)
Received: from [172.20.2.42] (unknown [172.20.2.42])
        by poczta.interduo.pl (Postfix) with ESMTPSA id D42FFE5441
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:41:40 +0200 (CEST)
Message-ID: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
Date:   Mon, 22 Aug 2022 10:41:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     netdev@vger.kernel.org
Content-Language: pl-PL
From:   =?UTF-8?Q?Jaros=c5=82aw_K=c5=82opotek?= <jkl@interduo.pl>
Subject: Network interface - allow to set kernel default qlen value
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Welcome netdev's,
is it possible to set in kernel default (for example by sysctl) value of 
qlen parameter for network interfaces?

I try to search: sysctl -a | grep qlen | grep default
and didn't find anything.

Now for setting the qlen - we use scripts in /etc/network/interface.

This is not so important thing - but could be improved. What do You 
think about it?

-- 
Jarosław Kłopotek
kom. 607 893 111
Interduo Bujek Kłopotek Sowa sp.j.
ul. Krańcowa 17, 21-100 Lubartów
tel. 81 475 30 00


