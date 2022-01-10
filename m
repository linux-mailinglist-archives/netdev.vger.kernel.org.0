Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF1948A158
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 22:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343705AbiAJVCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 16:02:18 -0500
Received: from linux.microsoft.com ([13.77.154.182]:50756 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiAJVCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 16:02:17 -0500
Received: from [192.168.4.54] (cpe-70-95-196-11.san.res.rr.com [70.95.196.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 81CF620B7179;
        Mon, 10 Jan 2022 13:02:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81CF620B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1641848537;
        bh=HAS3FJ65eHaVU80ZhbpqnKj+S/K9b7BggCz1pDIEDbk=;
        h=Date:To:From:Subject:From;
        b=ftFC7EftDCvZy/4pvp3oFjFv0ZcFJ8XSd5zvT2ib5RL+Vg0tVDAZoELHNoCTeu9GV
         CBST5AuvDIEwFknMc8Uh6pDslm8GmH/EuCv9X9cSdxl/1uJ78wtM/kqI2Dyp3RD6Av
         4guOy1cHpiy3VtyLAhxkBwcXGiwQsN6mn4YcmwWk=
Message-ID: <f7bcc68d-289d-4c13-f73d-77e349f4674e@linux.microsoft.com>
Date:   Mon, 10 Jan 2022 13:02:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
From:   Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: [bnxt] Error: Unable to read VPD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Since moving to 5.10 from 5.4 we are seeing

> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.0 (unnamed net_device) (uninitialized): Unable to read VPD
> 
> Jan 01 00:00:01 localhost kernel: bnxt_en 0008:01:00.1 (unnamed net_device) (uninitialized): Unable to read VPD

these appear to be harmless and introduced by

> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a0d0fd70fed5cc4f1e2dd98b801be63b07b4d6ac
Does "Unable to read VPD" need to be an error or can it be a warning 
(netdev_warn)?

Thanks,
Vijay
