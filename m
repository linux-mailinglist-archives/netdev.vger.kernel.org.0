Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45819779D
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgC3JQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 05:16:47 -0400
Received: from server.eikelenboom.it ([91.121.65.215]:58122 "EHLO
        server.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727276AbgC3JQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 05:16:47 -0400
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 05:16:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=eikelenboom.it; s=20180706; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:To:Cc:Subject:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QAtEIvYX/7+xN3Mi5dcj3FKSVE3ggw0yZWWxME0VaN4=; b=D3Hvt9/iGkW4B0YmTNr3XoLgJQ
        EYqdsFi0Ex7bCf1c5DTfPDOv7XHlI+LFhz2duIKsU7Ym8nJH5KV1BQyxkj8uLCXF4cx5SoCxgpb9R
        sTJ+kTRXCayiNg/81JN1SsCYVWTig8EPqUohWlbRFeH77/3B+5LkALOEKGUQOaitRFY4=;
Received: from ip4da85049.direct-adsl.nl ([77.168.80.73]:51748 helo=[172.16.1.50])
        by server.eikelenboom.it with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <linux@eikelenboom.it>)
        id 1jIqBu-0004Gr-PF; Mon, 30 Mar 2020 10:54:42 +0200
From:   Sander Eikelenboom <linux@eikelenboom.it>
Subject: Linux 5.6.0 regression: wlan0: authentication with 64:66:b3:xx:xx:xx
 timed out
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <56dfeca2-71cc-c601-06fc-4ebe9627ba74@eikelenboom.it>
Date:   Mon, 30 Mar 2020 10:52:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

L.S.,

Linux 5.6.0 has a regression compared to my previous build of Linus his
tree 5.6-rc7-ish (pulled and build on 2020-03-26), so it must be
introduced in one of the last 2 netdev pulls.

Both my laptops don't connect to Wifi any more, wifi hardware is intel:
    03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)

Logging shows a repeat of:
    [  512.085509] wlan0: authentication with 64:66:b3:xx:xx:xx timed out
    [  521.048959] wlan0: authenticate with 64:66:b3:be:b6:cc
    [  521.052416] wlan0: send auth to 64:66:b3:xx:xx:xx (try 1/3)
    [  521.053199] wlan0: send auth to 64:66:b3:xx:xx:xx (try 2/3)
    [  521.053209] wlan0: send auth to 64:66:b3:xx:xx:xx (try 3/3)

Any ideas ?
(will probably have some time to bisect later today)


--
Sander

