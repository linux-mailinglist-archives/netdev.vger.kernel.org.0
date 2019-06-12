Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9421420AD
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407596AbfFLJZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 05:25:18 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33437 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406207AbfFLJZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 05:25:17 -0400
Received: by mail-qt1-f193.google.com with SMTP id x2so16914774qtr.0
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 02:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=phtg8AlLrF1p4z7mdpZB8yC1WkMQ4cFheurG/+8Ktv8=;
        b=ZJRFgnWaqKzhh14GDgABiUMmKz9Xv5XAjfF+s5Ilmhp+ZS0ksyEOS1PgxUYUBS0xUL
         DycRs6mqLIuYgmwhkDAfCCI3tpjKuQbfFaR71Rr2ClhVcqawJf/FaDmzcsSEPq2Qm2pC
         xnholgTQV8pWeL8v41q75QZWLb/piGhG3oUD/XcKcadtsFJbr6zOid+lsjQpQnwvUqoT
         dqM0IRlgvEJvYMYzOWfv1zfj4cW0ODS6OUhUBeYNFPiilRWfHhjqupoWUZnoEI27PSU/
         /MsJV38mTViHFUqGU4pjg2Pj5QR3EAmgcdp2PoKi6SsHhh4rfmmIiBYqAj6vUNL0L/H5
         xeag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=phtg8AlLrF1p4z7mdpZB8yC1WkMQ4cFheurG/+8Ktv8=;
        b=D4x26flC/ozmSipX4Jyxd+AEHCsZlCXdAs2zGLZcY46rty3BF2v7mKd7bIBECILFKU
         k0DcK2u7lUwvCDp6bpw5OgGDpCdUf6z7Dy2RX796kZ6cgJGIJA47CHG4z1Fk5Kq8WnO6
         vfT1h8HZtnBJwylIo7mxkb4BXryp5lEbKYjzLIpfg/VJjWBSelmRtcytR1udyxG8iwxM
         eTrky/ujqXLQgKcgces29RwM8YJ0a4puWNWG8spcHqC8VXWdvzbTYk8gi5JqguMLEQy1
         xcu5O957eKr5oLHKoCUqdLEdppFmuEVwHh8hi7udZTP7cSAUGp3vG2AlwWohgsB8rK/Z
         qqJQ==
X-Gm-Message-State: APjAAAXrbuttDULgMR8rJxc+LYLRK8SsJ02oDpo+iYacD3Az5wNpbOu3
        A3+E3NfzFAw0Pya1fxRoUYpaS5Ob1B0CKuWxRPJFaHdsi30=
X-Google-Smtp-Source: APXvYqwpYxWsQ40mrMLp2/pLkNWH5SKI85us8a9fP/UU7sFmHWFbBqlbZzQD3Yrsv2aUQzrbF8W3JXOoRqrzH3ZGyck=
X-Received: by 2002:aed:3a03:: with SMTP id n3mr35316064qte.85.1560331516661;
 Wed, 12 Jun 2019 02:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190612092115.30043-1-liuhangbin@gmail.com>
In-Reply-To: <20190612092115.30043-1-liuhangbin@gmail.com>
From:   Hangbin Liu <liuhangbin@gmail.com>
Date:   Wed, 12 Jun 2019 17:25:05 +0800
Message-ID: <CAPwn2JRrWvGhNkWKt9B_e90i5xVdu7=Be=dBk0MGk1BNKwYHrw@mail.gmail.com>
Subject: Re: [iproute2 net-next PATCH] ip: add a new parameter -Numeric
To:     network dev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Phil Sutter <phil@nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 at 17:21, Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Add a new parameter '-Numeric' to show the number of protocol, scope,
> dsfield, etc directly instead of converting it to human readable name.
> Do the same on tc and ss.
>
> This patch is based on David Ahern's previous patch.
>
> Suggested-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

Oh, forgot to fix the subject line and reply the the previous patch, this is
PATCH v2 of https://patchwork.ozlabs.org/patch/1101870/

Thanks
Hangbin
