Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD6F425043
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbhJGJpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:45:24 -0400
Received: from host-62-245-130-222.customer.m-online.net ([62.245.130.222]:36102
        "EHLO muc.virtualbaker.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230389AbhJGJpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 05:45:23 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2021 05:45:23 EDT
Received: from [10.1.11.93] (che.muc.virtualbaker.com [10.1.11.93])
        by muc.virtualbaker.com (Postfix) with ESMTPS id 91719DE0B8C
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 11:37:41 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   c.heinze@precibake.com
Autocrypt: addr=c.heinze@precibake.com; keydata=
 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 FA==
Subject: 802.1aq
Message-ID: <23e6c5f0-9516-b1b8-8603-97aeb0fb1faf@precibake.com>
Date:   Thu, 7 Oct 2021 11:37:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i am looking for hints on any projects or progress or plans on 802.1aq implementations for linux.
i've seen there obviously are - commercial, proprietary - implementations for this on linux since many years, but i failed to find anything at all on this in the open/free world (except, there are is-is implementations since a loooong time already ofc).
any hints are highly appreciated.
