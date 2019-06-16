Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49214472AF
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 03:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFPBNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 21:13:04 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44376 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfFPBNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 21:13:04 -0400
Received: by mail-io1-f71.google.com with SMTP id i133so7680213ioa.11
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 18:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fHKEKHdPjoZhYVJRZoCAKKckDq3mCm+7VXF61UEPMbE=;
        b=IdinvP3riV1Zu6MpZJLjG/EUPFGiNsAl9RlU81anwd8GPN72kK7yT4O5F1f+jPfb9a
         gMcYlslKqJBCCA8fbf4SlMl43SJl95kgbnvw7ogC61oV1JdQJoj4fHKeBHMFarisjq+M
         8XfMV5+E7ODNYZDwTrIT3vX04/+DRL54RbT9nPZnB48nzd8irMnyrfuxniTMZqGTvj17
         WCA5Jv4+pywsdXexZtLribvGN8TyH97hmQYKCKZ0rCt6nctNsbyMyYFfwCWFTizQ+AnA
         YJf8nmwCYjR3tDd++JmLDzAKzCeBzChoqCz4USYH34/TRSbmh/mdvJDjSG6/9lF62GvH
         SpQw==
X-Gm-Message-State: APjAAAUlmCUrDK7SQQ1oZ1h8WOR5MsCsTp8D4+NASzFFWgB+naxhdUOW
        gLC3fgI8u41tjd3Tcts37FNL0QLMyD/YH1CxNG5TR5YD4qU2
X-Google-Smtp-Source: APXvYqz+u2Q7L7tpyT3UhpeYici7WM0yHAFm2QcnK/gM8n2t0zuxn0/rjGJlweypay4YtWjQna/l8FT8aJISslAwXlPKu0BSusit
MIME-Version: 1.0
X-Received: by 2002:a05:6602:158:: with SMTP id v24mr8817233iot.114.1560647583626;
 Sat, 15 Jun 2019 18:13:03 -0700 (PDT)
Date:   Sat, 15 Jun 2019 18:13:03 -0700
In-Reply-To: <00000000000009e6a5057d453454@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7818e058b669414@google.com>
Subject: Re: KASAN: stack-out-of-bounds Read in apparmor_cred_prepare
From:   syzbot <syzbot+59722316960a71d9695b@syzkaller.appspotmail.com>
To:     netdev@vger.kernel.org,
        syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Auto-closing this bug as obsolete.
Crashes did not happen for a while, no reproducer and no activity.
