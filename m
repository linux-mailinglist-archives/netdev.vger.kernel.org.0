Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC07168B06
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 01:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgBVAdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 19:33:50 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48818 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgBVAdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 19:33:49 -0500
Received: from [10.131.86.135] (unknown [131.107.159.7])
        by linux.microsoft.com (Postfix) with ESMTPSA id D54A820B9C02;
        Fri, 21 Feb 2020 16:33:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D54A820B9C02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1582331628;
        bh=xnkJ8j7rW1UeoqnfcEgj4o2S9dzSeeSCkJXJe0LZ8yQ=;
        h=To:From:Subject:Cc:Date:From;
        b=bA+nrq1ShJaDqvp0a6Z9OJ0V+Du2QSphzBo48XQzbizr4wxYFFDr3s3XrIbUUMiHE
         q6MFCOkbsHDAPEINVSYTtyyLEDLocJJ/cohFkAC5/vw4M6W5wYnCAHfjqRT9ChPK3p
         a4fmVg/QA0LeYI73Q/g2lCO7RG7i0XUUXduTR62g=
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Jordan Hand <jorhand@linux.microsoft.com>
Subject: net/kgdb: Taking another crack at implementing kgdboe
Cc:     jason.wessel@windriver.com, daniel.thompson@linaro.org,
        dianders@chromium.org
Message-ID: <ccd03920-375a-2e65-cc28-d00f3297cb67@linux.microsoft.com>
Date:   Fri, 21 Feb 2020 16:33:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey folks,

I have been scouring patches from around 2005-2008 related to kgdboe
(kgdb over ethernet) and I am interested in taking a shot at getting it
into the mainline kernel.

I found an implementation from Tom Rini in 2005[1] and an out of tree
implementation[2].

So I have a couple questions before I dive in:

1. Is anyone actively working on this? From lkml archives it appears no
but I thought I'd ask.
2. Does anyone have an objection to this feature? From my reading it
seems that the reason it was never merged was due to reliability issues
but I just want to double check that people don't see some larger issue.

I don't have 100% of my time to devote to this so it will likely take me
a while but this is something I would like to see in the upstream kernel
so I thought I'd give it a try.

[1] https://lkml.org/lkml/2005/7/29/321
[2] https://github.com/sysprogs/kgdboe
