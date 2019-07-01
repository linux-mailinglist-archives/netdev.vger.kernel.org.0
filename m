Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C3D5C519
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGAVm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:42:29 -0400
Received: from mail-yw1-f54.google.com ([209.85.161.54]:44882 "EHLO
        mail-yw1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbfGAVm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:42:29 -0400
Received: by mail-yw1-f54.google.com with SMTP id l79so544014ywe.11
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+kIX5vsmoR5+2saIsx/oasPVjglBrEdj83w5hyy8CjU=;
        b=PZ53CD9rB+YSnrwnad/4knf7aCy3Z9146rlAfTztE/Vwn+l48iE0cm4u8sHJF7ilIF
         Noyd7oSAuzbh2UfepNW7F03x3yijDOnlGhfLhBDKx0HbvI2hpPrpEeZt7P3pK6ZqB1cH
         Ny28zz+q4FJ4DWBYi14RxFMFnwpuHdQvqenPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+kIX5vsmoR5+2saIsx/oasPVjglBrEdj83w5hyy8CjU=;
        b=V1HAlBOsHIdyjkWw3A9tRU1isfIaZyg/k8In6rAyFP02oKycjhOGl2kamE6g1WuDRD
         G65ifcDd0Vu0Xq+zC1pXQZ31J7dDFMW0cfeeewtnhPhCe8E3Kq/7srmaUv3lrQ9tCpUs
         M1Fhs3aKwH9NzktmLSNb6EDFoAA9zMavBykIVOJy3AMdEcb+Y2RsrAJaFkUhRyy/x0zD
         Udx6X3qw5MUWjSlqC92n7T36i+1Ewk1W4q8E/jLQOlZFtC13GLvfU/bDjKQmpIQNdZUH
         Z/I8w6uzAILyoAibn5Fn8lj+18YXv6rHfBDqgDkV/8/81z3HjcFU4V8NSzUl1Dqp/UK0
         A86w==
X-Gm-Message-State: APjAAAXMqzlMrkgV7+vOEW7ZqZwBUP77R/nraS6+A4Kcv6kIZhZ0uzpp
        iZdRUkaEgXF6z4EQofLf320waA7GP9C8gId7aQLYZA==
X-Google-Smtp-Source: APXvYqxWL6LVGvhCmt986nEYIxJ2YsCkjveun0oJx9LMNCKuFbz+W6iigE4mV5mpBUMOoBHuZhPTN/7P3VccRNZfoOM=
X-Received: by 2002:a81:f87:: with SMTP id 129mr17190095ywp.421.1562017348554;
 Mon, 01 Jul 2019 14:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190701213857.103511-1-maheshb@google.com>
In-Reply-To: <20190701213857.103511-1-maheshb@google.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 1 Jul 2019 14:42:17 -0700
Message-ID: <CACKFLik9n=LfwBKBmsjfbDygjshfApfe=hX_zxuQNUq0nhpMXQ@mail.gmail.com>
Subject: Re: [PATCHv3 next 2/3] blackhole_netdev: use blackhole_netdev to
 invalidate dst entries
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 2:39 PM Mahesh Bandewar <maheshb@google.com> wrote:
>
> Use blackhole_netdev instead of 'lo' device with lower MTU when marking
> dst "dead".
>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Tested-by: Michael Chan <michael.chan@broadcom.com>
