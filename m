Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820361BF54
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 00:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEMWDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 18:03:41 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53085 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEMWDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 18:03:41 -0400
Received: from fsav102.sakura.ne.jp (fsav102.sakura.ne.jp [27.133.134.229])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x4DM3Yok075530;
        Tue, 14 May 2019 07:03:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav102.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp);
 Tue, 14 May 2019 07:03:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav102.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x4DM3Yuw075527
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Tue, 14 May 2019 07:03:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: bpf-next boot error: WARNING: workqueue cpumask: online intersect
 > possible intersect
To:     syzbot <syzbot+9e532f90f6ca82f39854@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <00000000000054d5650588cb2c27@google.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <3307c238-83d2-2561-013b-ce3159eef044@I-love.SAKURA.ne.jp>
Date:   Tue, 14 May 2019 07:03:34 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <00000000000054d5650588cb2c27@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore

  net-next boot error: WARNING: workqueue cpumask: online intersect > possible intersect
  bpf-next boot error: WARNING: workqueue cpumask: online intersect > possible intersect
  bpf boot error: WARNING: workqueue cpumask: online intersect > possible intersect
  net boot error: WARNING: workqueue cpumask: online intersect > possible intersect

reports. These are caused by
https://github.com/google/syzkaller/commit/aa8482aa8acbe261c9413fd4179e8163069b7605 and
we need to wait until CONFIG_SECURITY_TOMOYO_INSECURE_BUILTIN_SETTING gets propagated.

