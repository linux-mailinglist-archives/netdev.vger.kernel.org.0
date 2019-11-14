Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3C9FCD5D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNSWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:22:52 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39910 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKNSWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:22:52 -0500
Received: by mail-qk1-f196.google.com with SMTP id 15so5841402qkh.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ixvbZIvk67wZYSzDyeWxAvPmZ5b8Faj2xs2Yx1iXg+g=;
        b=BMEm9HvdZYRecnYjTuJUZAbqAOLUHuNOmXCNkBLtts5hw/cpNzmz9Iz/XsLPHaF4JJ
         rxtfNZMUa6QrEqA2/nBz/Ud+jjNDL1vUQMyjxOBC/55GN88qEyNTkxsr9GvBmlPauvm6
         PCRIEqllckxTnCGfK4aKU6vqw1pUphl6g0ORrFsf3zCl7T9WNf9S9c+yJcE7vQWDWf18
         2LVmG+N9GTTWHo882mD6SBaEK6rwE2YQADHTPdC5yIgP2/IAeiRbN8JtkTgLTvjETGx+
         vxZT2EOo4RBTwhjWCk6FYE9EBwRaTZSXQed6TEzCHkeAPfX10AMuRDTSstRIUTgVNQbW
         nzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ixvbZIvk67wZYSzDyeWxAvPmZ5b8Faj2xs2Yx1iXg+g=;
        b=nNWNpnFAb3OptTENqos1D9UrvXO9sv+5Lm98DpOVTA12yDNFR2GZnhx6RZdiGArY1R
         vhmSZgcQCvCi+JVaYgj+ZqJ2oZ8C0uAA2KGyISbLuqgjg40v+imCnDZXdH8OpbMbE+k3
         vCNoLkx8y5XnezBzSfkPcex1W5oPnKv84jv29F+wCDTDgre2fcx5pcTq5gx6E59jFQKp
         63yOwKig3sAfC/ilIx2d3K0iSOVqNkdbcRNLJE9j0ttKRdRrPg3GuQ/8tBdjPA8HF9PU
         JPPaDjjpWjH6rNSOJkDCKmYi+MWs/l6vIj0kizqi8NW1SICE9BSHxNMpR1M+3IWBzlAT
         rIlA==
X-Gm-Message-State: APjAAAUxt6mBz0DXXEYYN+gwc96evPaxfdWByJTHRDJbITLMkp2AG/o5
        qAYRpgwIrCRjAcy5qwj1DtY1Eg==
X-Google-Smtp-Source: APXvYqyvxOOoCu435dY17WGi/5/UtVVSJxJjqPluG0ElZFQyy03zfMf19tWv/TOzHXgbMwSJswncmQ==
X-Received: by 2002:a37:ef11:: with SMTP id j17mr8624147qkk.397.1573755771517;
        Thu, 14 Nov 2019 10:22:51 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id l186sm2829234qkc.58.2019.11.14.10.22.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 10:22:51 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 0/2] Updates to tc-ematch.8 man page
Date:   Thu, 14 Nov 2019 13:22:34 -0500
Message-Id: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the list of filters using ematch rules, and document canid()
ematch rule.

Roman Mashak (2):
  man: tc-ematch.8: update list of filter using extended matches
  man: tc-ematch.8: documented canid() ematch rule

 man/man8/tc-ematch.8 | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.7.4

