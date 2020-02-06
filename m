Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB98154E35
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 22:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgBFVll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 16:41:41 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:45814 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbgBFVll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 16:41:41 -0500
Received: from [10.0.0.63] (unknown [118.127.122.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1E69C137586
        for <netdev@vger.kernel.org>; Thu,  6 Feb 2020 13:41:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1E69C137586
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1581025297;
        bh=WdV0CFrLdGTP0BxTXf8HToOupV0zmfOUldKbpGArzEk=;
        h=Date:From:To:Subject:From;
        b=hKRvGm95e1Ln5dBX4qxAy8E/QZBvOZ3990/kWZlKaA7nu6z2m6Ai2S3eUD93DFEzV
         wzY5aed+lzEveepvN//eZJGBibQ3koIfBfWCbI65uC7mYoRkIMRkDf8GciSsIE3roM
         Bb3qD3b1P7YjbQQLuNG/hP3AjymLVrblVp3ug/xI=
Message-ID: <5E3C880F.1060708@candelatech.com>
Date:   Thu, 06 Feb 2020 13:41:35 -0800
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To:     netdev <netdev@vger.kernel.org>
Subject: VRF:  Any good way to have DNS entry per VRF?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

While poking around with a libwebkit app, I realized I need a way to tell libwebkit to
use a particular DNS address that makes sense to its specific VRF, not the global
DNS address.

I am loathe to try to patch something like libcares into webkit, so curious if there
is some better way to have a DNS configured per VRF?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

