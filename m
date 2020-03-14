Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3A6185905
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 03:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgCOC36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 22:29:58 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:34553 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgCOC35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 22:29:57 -0400
Received: by mail-qv1-f68.google.com with SMTP id o18so6928237qvf.1;
        Sat, 14 Mar 2020 19:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZEEnUHwkZMDbVRFi/MzyKhwtIiz6HxIBrFlnIEc6RNU=;
        b=UtF1NsDXnHj+58UszKvNBbyAK47c838ncpsIkdFCBW1JmsCtG/hHuFT52R00vV/4vB
         2LUJSnHt5bkbjBIeHkQ7ylDQMQtr3B7u2xmhxHBD9aYSsZtXN/LrDGRLfSK4P7WXJcar
         nBMyLw4xmX/JTb4DsZ128A2fz3hhIdx0ceTtpGmlRPsPOroVerSCgePvQNgIp0vjrSu1
         /qX2OY1rm41zsUbGaUiNaYqZIeeKat+5KrtJFJkvmur5YBRnbvQnuk1b67Lt//p6isTw
         nMGqfpJ5Bc/tjuMDFsbmXDL7sOoKR+/s3IgQfkygtsqJ++a9aRhBnxkHvsye/ig6zo5h
         0dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZEEnUHwkZMDbVRFi/MzyKhwtIiz6HxIBrFlnIEc6RNU=;
        b=MzqrtO4nhRRUMYTD9wds/pamtt064U5oOaUFZrOpOAKzPoLOelO/p7bLGSoIOKjAuy
         0aztVcTKoDWNilwYuIx2vW5NW7W67O1xoGSTWXQBUyj4GfhPnJTFsTvd+8H9Wee7Xaku
         RSl0XBkhPBvNdHc+UVtM5ia9wABQuXrqy05iTXNBX/v5gB99t1CrZzxJZpIbgX3ekA44
         Vz2APkSZJTwqAYZIXtNGbuRzcQfI3JKAu2zApoWOLzoBBZ2A9sHb5UuX0NZMadNBPRXx
         mxLyMR6hR9l0MVpr5Xi8kuXL/fVsd+mm3buwwuffg4h2cxaxKEaH4kgtjOLEyN/UWxYD
         Pj9w==
X-Gm-Message-State: ANhLgQ3MrU4c+5vZA1W77aRcclnQtfi9b5ATzu65Rb2tot87MLjXZ/iu
        OzI4sIqBhyyaGLZqkL1FFfZjFMcGjiowA/QivDKiz+OdOdGYBw==
X-Google-Smtp-Source: ADFU+vvsK8JvrXqPEXbA+j7zJUHM/6+ENQ1291U9h/aHYElOe7G36evoxnEgLffodJB2/XLtPIBp/qBsrOkSjmVlaCA=
X-Received: by 2002:a67:3201:: with SMTP id y1mr12293028vsy.54.1584162630149;
 Fri, 13 Mar 2020 22:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Sat, 14 Mar 2020 13:10:19 +0800
Message-ID: <CADG63jC=oy4PTRbw=6=OMdG3nabf3-AdjDKcH4FKJwNg4A-s5g@mail.gmail.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
To:     syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/hqj/hqjagain_test.git sctp_wfree
