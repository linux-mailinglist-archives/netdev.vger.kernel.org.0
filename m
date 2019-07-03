Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42C015EF83
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 01:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfGCXFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 19:05:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43581 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCXFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 19:05:47 -0400
Received: by mail-io1-f65.google.com with SMTP id k20so8815917ios.10
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 16:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vFPN19sE7ysY8YvFFjusSzIZiwIbCJpLduVsj4SmypE=;
        b=V45QrL680mQAf1Ckd+CGGqcvWQ3c46ho3kPFfX1G8B51xSkqmoWH5cpCq6WvviIsOu
         fY644/pQ2F8LfY29O9k1zJCH82qtg8+guzEDPuqNgWWx2pyxXyJGsQCcj9rHDUvO5/qo
         xxr99YhjiklkzklEU/b7dgBRbNv/wfEBEsI43S4YhtVnTWdhbnlvBs85Um1zM1mK7Lyb
         kUASuNFFSyVX+kChOV6xHkmtd9BFWpnS841utjYlkdGdKcgxt704ewgK7KIcZhzAx5uB
         bCtJDk58OUINSORBe68HvOe/99KauXIfbJFnXS5GKiuAw6P3ELZj1gORKTfbE4WadLhr
         DaBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vFPN19sE7ysY8YvFFjusSzIZiwIbCJpLduVsj4SmypE=;
        b=lF3YXuKfv8AjSB4D7zdnNOtWpPxN+Hu4usK8p5P1bI1ndzETQ2KqQdJqPq/sdq2MH7
         8iStI4mV9loTRYOZw9meN0uc3gBFON4gsOOhUFcOHlqjfsLamNSiipT5KAd7VbF8EMg/
         TDXGrUOx2ysjj6bEeycl5H57EeEK6Xp0//QSnHRuRu+HbmKsgKfCSHk69c1PTenmNlwf
         23f/zPz3OkCnm3VtBR47Q++udQpEnrf68iDLG/udD8uLBHoWOvjk11ifuN8oECdV4dXg
         fSKOvoLpY2l0IHI+pd6FCz1PTwxfrVYv0+WK07Xx65hxU0R+0xLVDT+DHNQLVNa4QjQH
         HK3g==
X-Gm-Message-State: APjAAAUR87g5zSO418TZEZlANM6xgJFdZUWfbMVXcCia0lu5rePWqQ8Z
        SiFGdA0SCjnIIfW/v3I4Au+G+w==
X-Google-Smtp-Source: APXvYqx/aY6pfk+wyih5pqE0S2pmzezUc1M9uvU/g7/oW+vP14XCOm+h1FSSSBOrGPJvK/EnXqwDXA==
X-Received: by 2002:a6b:5115:: with SMTP id f21mr705938iob.173.1562195146446;
        Wed, 03 Jul 2019 16:05:46 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id x13sm2803180ioj.18.2019.07.03.16.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 03 Jul 2019 16:05:45 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 2/2] tc: document 'mask' parameter in skbedit man page
Date:   Wed,  3 Jul 2019 19:05:32 -0400
Message-Id: <1562195132-9829-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
References: <1562195132-9829-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/tc-skbedit.8 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-skbedit.8 b/man/man8/tc-skbedit.8
index 2459198261e6..704f63bdb061 100644
--- a/man/man8/tc-skbedit.8
+++ b/man/man8/tc-skbedit.8
@@ -9,8 +9,7 @@ skbedit - SKB editing action
 .IR QUEUE_MAPPING " ] ["
 .B priority
 .IR PRIORITY " ] ["
-.B mark
-.IR MARK " ] ["
+.BI mark " MARK\fR[\fB/\fIMASK] ] ["
 .B ptype
 .IR PTYPE " ] ["
 .BR inheritdsfield " ]"
@@ -49,12 +48,14 @@ or a hexadecimal major class ID optionally followed by a colon
 .RB ( : )
 and a hexadecimal minor class ID.
 .TP
-.BI mark " MARK"
+.BI mark " MARK\fR[\fB/\fIMASK]"
 Change the packet's firewall mark value.
 .I MARK
 is an unsigned 32bit value in automatically detected format (i.e., prefix with
 .RB ' 0x '
 for hexadecimal interpretation, etc.).
+.I MASK
+defines the 32-bit mask selecting bits of mark value. Default is 0xffffffff.
 .TP
 .BI ptype " PTYPE"
 Override the packet's type. Useful for setting packet type to host when
-- 
2.7.4

