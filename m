Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD8AF1CD
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbfIJTUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:20:39 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:35688 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfIJTUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:20:39 -0400
Received: by mail-pf1-f178.google.com with SMTP id 205so12122018pfw.2;
        Tue, 10 Sep 2019 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hjznco4o+Dn2VZDtAq/yGZeHT9P3y4uXRyWwDlemFd8=;
        b=dbad3cwS3bDXPXiia9RQOxLMxcCGqZO4+b9pM/wM5CA0PyGVDYA5yr8aBY4DsMN1N7
         6kx4wLnjH9RnixBOI+XZDwA2PXkae1VpOAG71leCuERWo762t+CKEMr+OntzMFI83DZs
         XlXE3G065vOSrrv6l3w1CXw3QwSuoiqILjlukElsnnzwbexoMU4ejxHixn2Uk0s/rueV
         OzZgGk+d++G4jH9n/qAcNNiW9la3nrF3/lGmBh3etyaoG36K0y9uijbf8b5mzNlbN7v+
         fLiNRugxBdu2tfelixWCVOCA59dUhwffC73i+Bwyf7TjhX2td6k/mww0w6YUMXwxCmyc
         mPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hjznco4o+Dn2VZDtAq/yGZeHT9P3y4uXRyWwDlemFd8=;
        b=TijoTTkYV9uT5zKqUv17DtvLKVQw1WDcdVxKTeLvyfCdlBkOkHZFtrGfuJyVq/iBct
         aYuSODxIbm1iOAVtLHXExnq9eozpo1GKVoS5iR9t/FPutEknTJHgSQTVs7YPoQ0zNNTH
         WTZXpxBfstCaEkXc/Zss6suV8EvOqSgPH/Q76mAvTc0uTOWbmK8ViTICFlsNw1Byy+k6
         ol3l1Vvmh5eHYLCqFpY+8gAgbyU4HIXUeLHaobfaJdgyZQ4HR+R7bLHn4QLOO3l5o76m
         u9YGfjbNV1D4HQPmLCfv5fDBifM2RvKMAfwx/01njCdCtSncWJnAtdzJyDftdKW2luOj
         LRCw==
X-Gm-Message-State: APjAAAVZuTxxNqqZYD0/ehle9t0kGclMVUaH+HUYte+X32KxRP1riyT1
        H6KtPaOCHBBaBLNRj317GnaXAKQKpeRLrdW8l9k=
X-Google-Smtp-Source: APXvYqw/HUFmrOU8dCiX0+yLftcHJVhZDygwUw4PA7p0G0QzOsod91uplKxeY9bzTmrCWVN7zKwfjR76Jx9zNF5eu5k=
X-Received: by 2002:a63:36cc:: with SMTP id d195mr29148700pga.157.1568143238774;
 Tue, 10 Sep 2019 12:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bcb83d059237c30a@google.com>
In-Reply-To: <000000000000bcb83d059237c30a@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Sep 2019 12:20:27 -0700
Message-ID: <CAM_iQpVT3P_mrPtVOayfdRKpLvEO_YtkjrDK3uX_G7P1MzM8EA@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in br_handle_frame
To:     syzbot <syzbot+2addc1f058bd021b0a40@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
