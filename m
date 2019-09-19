Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FAFB7B96
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbfISOF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:05:57 -0400
Received: from mail-yw1-f50.google.com ([209.85.161.50]:37543 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388331AbfISOF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:05:57 -0400
Received: by mail-yw1-f50.google.com with SMTP id u65so1268342ywe.4
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JZPv3jG+XlPrOTjewHyQ0ssMtO4G5mbxB4JHojADKFM=;
        b=TehwRmBY1MMWldQQlRo239kMPpR2q0ej6PO84UVEYY0+aHI+zTEadOOA/DzZiKQk3r
         SRA5Y//v0OKHEz1lK+TyTZnd9bW1onyQXh46O8XV2ETqDXXtxNfMuBcRSa1qY1PQDC02
         fwi97l6Q1Z97XR/dd7Y1DxzZZQuapf7z/6d9L9h17ngqAUrqYFu3vDSrVDfjKFL2iIZO
         STe1ZXAyxP0VmuKFZaVPz2QlcQJBPqkxyQvDRmG6Emz5oF2IfvfPSYMBxheWqE2ZZs/y
         ju5UPFEKL8Beb4Oi/8ueeypBqoVSZ1FxcOhIRPN4zvUR7dEj9KbBnkmBzzpwF69+Qtrq
         KbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JZPv3jG+XlPrOTjewHyQ0ssMtO4G5mbxB4JHojADKFM=;
        b=kouS+ANNBU+vfD9G3bJR7MzHln1mFB4+9+M0HlC/58wSruETUIX/HelNhoPCTsCKdS
         +x/FBbv8nWohtgg2qQVAVO8c60mJsk6K5qFPcye4CFK8nbefwVuPwjjxd6f3R6G44e8N
         5buxyO4VwKEIx63ewLb1AaKC26w/pfdCd2yjDePmxT4z+t5KXw1YBZMsOVUofbkIJCgT
         ZAo60vKe9GKBrF2id9Iz0xODz541vog5HnX6/PZELP8DUj4XyDfVIHR0rKvhxcIqf/bI
         cgezx+KDETq5FFWY2KVr0P1bn4NOnqVfi95u+BY0RR3/hVaKln5kp3yp5/vPgZodaaQ/
         9B8Q==
X-Gm-Message-State: APjAAAVbs5xQ5fO+p7dAJmCs1BRc2fwSjFsKBrjabYhLtL0PsuQnUkQ7
        F54LHzKjrFoTDa6zTgFryIB3TryAr/17iAanjLM=
X-Google-Smtp-Source: APXvYqw8egP5C/WoeEqtF9EuxT4W6NU661kTcmlwLNJ+o1OHArA5LZXVI6o8tUUJjSdvuUd53CZELpt3sc+l2V1FNco=
X-Received: by 2002:a81:4602:: with SMTP id t2mr8354885ywa.391.1568901956583;
 Thu, 19 Sep 2019 07:05:56 -0700 (PDT)
MIME-Version: 1.0
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 19 Sep 2019 17:05:45 +0300
Message-ID: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
Subject: ELOed stable kernels
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

If this is RTFM could you please point me to the Emm

AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.

Is this correct?

thanks,

Or.
