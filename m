Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1534B8EB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 19:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhC0Sc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 14:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhC0Sci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 14:32:38 -0400
Received: from resqmta-ch2-08v.sys.comcast.net (resqmta-ch2-08v.sys.comcast.net [IPv6:2001:558:fe21:29:69:252:207:40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152AC0613B1
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 11:32:33 -0700 (PDT)
Received: from resomta-ch2-11v.sys.comcast.net ([69.252.207.107])
        by resqmta-ch2-08v.sys.comcast.net with ESMTP
        id QDi2ljxaW5RiAQDjclO2sC; Sat, 27 Mar 2021 18:32:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20180828_2048; t=1616869952;
        bh=a5wnhINePxnUffQVcDsGwGa4BvAs4dm1nuUfxl3z4Fk=;
        h=Received:Received:From:Subject:Reply-To:To:Message-ID:Date:
         MIME-Version:Content-Type;
        b=BLRSQva/+pyoNoNzdsWEqPDoLDetfx/z/f2VkQPQbUc5IqsteEXTSibtC9K26dwg8
         Qns2TtqF9aSiqNNYxc1IQUvB7EkoSNoEpxydAt+fT13ULH+BpDsvGEGX3FIyJsryD/
         otAXkw30jSZZsl08gnLJ++kxzr+nyTj55J5swRlpmdq3dylSz+qX6koMJTUXiAD4Lo
         0yJYLdzQ43LORxO9Yj9U0TECoNVNb/EdfTMbs/UALmcCPhxQz5Xt5D2s6nXs6JfitS
         ZKP4blf85JzPXJufGf0oSJzPfAvVwgrww2wtl7GBCrXNBkCAtKxTqezVaSw9xR3bTW
         16dk5PHF2OFeA==
Received: from [IPv6:2001:558:6040:22:2171:426f:b27e:296d]
 ([IPv6:2001:558:6040:22:2171:426f:b27e:296d])
        by resomta-ch2-11v.sys.comcast.net with ESMTPSA
        id QDjPlYl3S1sLKQDjcl4VRK; Sat, 27 Mar 2021 18:32:32 +0000
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   James Feeney <james@nurealm.net>
Subject: Upgrade from linux-lts-5.10.25 to linux-lts 5.10.26 breaks bonding.
Reply-To: james@nurealm.net
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Cc:     netdev@vger.kernel.org
Message-ID: <41a8809b-efd5-4d5f-d5bb-9e0d2f2e7eb4@nurealm.net>
Date:   Sat, 27 Mar 2021 12:32:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Downgrading the kernel resolves the problem, but I don't see any bonding commits between linux-lts-5.10.25 and linux-lts 5.10.26.

My mistake - 9392b8219b62b0536df25c9de82b33f8a00881ef *was* included in 5.10.26.  Thus the "Invalid argument" message.

 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-rolling-lts&id=9392b8219b62b0536df25c9de82b33f8a00881ef


James
