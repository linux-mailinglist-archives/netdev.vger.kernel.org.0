Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233C3DDFE9
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfJTSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 14:11:08 -0400
Received: from mail-io1-f43.google.com ([209.85.166.43]:38965 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfJTSLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 14:11:08 -0400
Received: by mail-io1-f43.google.com with SMTP id a1so13190107ioc.6
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=WwwOJG6cLnG5xe3kjsXT2ilCOHWGZRdMg+j74Vw53t4=;
        b=xIRXpq8f/TDXgDmgVcZmBmcpBA1YW2MqqLg1daMjdWhX29XZxDpk+kWpAbHEc9I9ak
         QvZk0TsCqH8w+tGANCynHQASn8DjmWLsCvql3TAMT6Sl4YSOJHhZ0Ubr2XRydLZW2b8S
         uX2+tIPVXTRL6jA8P5UDWJhIlmSC4FBNjJFWJOpADWdR6+A/LhT7sDXrSsYGLUdXmCcM
         svh6WrY1AREuxupY5jZaNQFUWvYL+0HmIlkPpg4b4OADBTPojBAlotOydJHDMiqAE6Fz
         +IOFGJPqAFYRPBlE/p4t+f9EWrOeiYNhfmctDfjwzMIZEVUN6YHBHDRgIClvdY/G5yBN
         jloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=WwwOJG6cLnG5xe3kjsXT2ilCOHWGZRdMg+j74Vw53t4=;
        b=VDkHkegSjD8jYPVe8rlkb75K4B8SNZJPk5JvBQJUMEGigUiWPV1p6RZZIBZk9PTvlG
         B3+qq5yBmlyBrIaHF+11q0EhJXuqkDhlwHZnHa/rGm0fvrsasgNNHaGpk6wl4feSHVBW
         YiX0byOvGojYNa2fmJw2E335pXIS2m+zJKchgVBkV8M4hadZ7rJfs5Ze5D4WU3deYUOl
         ctamR0QLPpWKFKhaDCvWpmo+JZRCdTqhvlC9QngbujVF/GMtHn8YX0CgnVsicThoEj+O
         6SRBNKl/l5wy7gXQVefnud3fTRG5K49JLVgUbbX/zwBOsTTVjhWx56WcNZPCtK56NXga
         dQaQ==
X-Gm-Message-State: APjAAAWjQ6YjjKJr77/yJMsiQMKcsVHt89241CKZNvW7Xm2bEetLvkL5
        uWM1XQBIsU4xs4jgnAuaUhqDsA==
X-Google-Smtp-Source: APXvYqy+g0dW6i2W+ZwUWXvHoX5E4PThQJkpc6ElQkdeecg/jBrJXQlBfbZsm0QTf+vurjU7oUVUGA==
X-Received: by 2002:a6b:d812:: with SMTP id y18mr859466iob.151.1571595066005;
        Sun, 20 Oct 2019 11:11:06 -0700 (PDT)
Received: from [192.168.0.124] (198-84-204-252.cpe.teksavvy.com. [198.84.204.252])
        by smtp.googlemail.com with ESMTPSA id x4sm4448657ilm.57.2019.10.20.11.11.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 11:11:05 -0700 (PDT)
To:     people <people@netdevconf.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: CFS for Netdev 0x14 open!
Cc:     netfilter-devel@vger.kernel.org, linux-wireless@vger.kernel.org,
        lwn@lwn.net, netdev@vger.kernel.org, netfilter@vger.kernel.org,
        lartc@vger.kernel.org
Message-ID: <65cebdca-7ed1-2bb5-450a-0bb8de7b6ff3@mojatatu.com>
Date:   Sun, 20 Oct 2019 14:11:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



We are pleased to announce the opening of Call For
Submissions(CFS) for Netdev 0x14.

For overview of topics, submissions and requirements
please visit:
https://netdevconf.info/0x14/submit-proposal.html

For all submitted sessions, we employ a blind
review process carried out by the Program Committee.
Please refer to:
https://www.netdevconf.info/0x14/pc_review.html

Important dates:
Closing of CFS: Wed, January 15, 2020.
Notification by: Mon, January 20, 2020
Conference dates:  Tue, March 17 to Fri, March 20, 2020.

cheers,
jamal
