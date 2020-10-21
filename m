Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A002951CE
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503747AbgJURwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 13:52:44 -0400
Received: from bobcat.rjmcmahon.com ([45.33.58.123]:45142 "EHLO
        bobcat.rjmcmahon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503714AbgJURwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 13:52:44 -0400
Received: by bobcat.rjmcmahon.com (Postfix, from userid 99)
        id 555961B270; Wed, 21 Oct 2020 13:52:44 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 bobcat.rjmcmahon.com 555961B270
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rjmcmahon.com;
        s=bobcat; t=1603302764;
        bh=72MTgkQMaFfC/ovu+ZgAWH2M67GIcZCPeeowlZ2B69E=;
        h=Date:From:To:Subject:From;
        b=aQyNLPWEjqy4sIvlrA23mKs53lN6Ir211HRUl4yH6qkVMJcEUfRXpD4ZrufmmTObs
         99nASqJePnrf7kw1Wisid2HfJ7tiNLFcSgJxFrsDtPikSGy90A7qotQq/AIL5ov5mM
         64kJWrACtttDpTUNXuLcRWrl0AOZvuiw/d7GLamg=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on bobcat.rjmcmahon.com
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.2
Received: from mail.rjmcmahon.com (bobcat.rjmcmahon.com [45.33.58.123])
        by bobcat.rjmcmahon.com (Postfix) with ESMTPA id 11F771B261
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 13:52:43 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 bobcat.rjmcmahon.com 11F771B261
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rjmcmahon.com;
        s=bobcat; t=1603302763;
        bh=72MTgkQMaFfC/ovu+ZgAWH2M67GIcZCPeeowlZ2B69E=;
        h=Date:From:To:Subject:From;
        b=iurL2m3WWG9pdwlCKBeTkLWIIpcdkhxp0DEQbQPsX/LkIF/4o6Yi62G4udNzwQQ6t
         Fi1+IVYmxFPTt2sFGBjM8Bh/WcjBSw2nxPmY8kl8Gmm4nmFmSRlWYQ5/aApoPwQfzk
         Jovuhl581GASn6DLPRLIqmigWviXfDMJTn8FDleU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 21 Oct 2020 10:52:42 -0700
From:   rjmcmahon <rjmcmahon@rjmcmahon.com>
To:     netdev@vger.kernel.org
Subject: pressure for better clocks
Message-ID: <3b2a423ccc6be227054ab78108f3269e@rjmcmahon.com>
X-Sender: rjmcmahon@rjmcmahon.com
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Iperf 2.0.14 provides end/end latency measurements but requires sync'ed 
clocks. The lack of attention to network latency is a major deficit to 
the networking industry and impairs user experience.

I find one of the many problems with the tech industry is that cheap 
mass market stuff proliferates.  An example of this is the oscillators 
used for time keeping which run things like CPUs.  There are many ways 
to get better time without spending too much. The GPS atomic clocks are 
basically available for free over most of the planet. Cellular clocks, 
synced to GPS, are available indoors.

Here is a good article:

https://www.pcworld.com/article/2891892/why-computers-still-struggle-to-tell-the-time.html

"But computer makers often use inexpensive crystals costing only a few 
cents each, which can compromise accuracy. “If you buy server-class 
hardware, you will get cheap crystal, and time will wander if you don’t 
do something about it,” Neville-Neil said.

The average crystal ends up being about as accurate as a mechanical 
watch"

Bob McMahon
