Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACC3E6064
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 05:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbfJ0Egb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 00:36:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:32870 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfJ0Ega (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 00:36:30 -0400
Received: by mail-ot1-f68.google.com with SMTP id u13so4711033ote.0
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 21:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjdMJeeRCP/2LcU45GXk4+A0a869QbmUnH1wlVeAy7U=;
        b=hcBWa96p+3d+/J+Q3PwMdV7f03OTEcJFAowFkq/BvnWiMtnetgx7OWzl3ElW7zW5U5
         4w5yFpdH6SaxCpII/wYDSTihvywHFnoCttV2yuc1SnyEbBtfUy2BLbDXlqgN4qbQhkcK
         kUIWhAUsq6LD0GFqnWYB97hO07OckF93H2Q0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjdMJeeRCP/2LcU45GXk4+A0a869QbmUnH1wlVeAy7U=;
        b=QvfYLr8lrGcPYuUCYp8wyV0SR+2DOSWKka9803sP5YuzMB8mwYDHUkyjv8aE90rrKj
         8rkF1elKqVA5YqUV+tNbq17dgNc4esZUI+sBhWTWH/QRFNygcinXVQh29deoZzEEJ/Ps
         nDMdG8iqFRgeIoxmm0HxHI0/Z9HuAwfAJGoFGgBellEbdwz45rl51KDQHX9sCyNy4k+U
         cELvLNrhrjwHPG9qK+0mjW3vGi+9buEpBUAvo209FWfqHRoOApTCk7F8m0vqLjp7dxja
         6JA9QPlOIophqYhEZjmcqLwW9dDJ/QPSjjlrN9wz94ZBOrqS/o00Sz//fcBkMHlYMhmo
         hqhA==
X-Gm-Message-State: APjAAAX1ZOzPiqhz1BpSvi9QPRiXBNVmRIZ7aQosI9VTqWwmPlKp2My+
        X1SBxdcJ3WaPRUg0dytvt2x8jhxyoR2BKCmMjdrKkA==
X-Google-Smtp-Source: APXvYqwwhalYg1gkdWHBSUYpiMBn2jlMbmYeChap2T/TdG7wET5CNRCJsY+zpTjC++ovSDZtLKJFVXKNvAPiA7GNsa4=
X-Received: by 2002:a05:6830:1ca:: with SMTP id r10mr204940ota.246.1572150989932;
 Sat, 26 Oct 2019 21:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191027034937.GA7401@saurav>
In-Reply-To: <20191027034937.GA7401@saurav>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sat, 26 Oct 2019 21:36:18 -0700
Message-ID: <CACKFLi=+WNCZGC=r2c7R_fxojpEMiFf59qEkJefu2NcFgcF5Tg@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: broadcom: bnxt: Fix use true/false for bool
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 26, 2019 at 8:49 PM Saurav Girepunje
<saurav.girepunje@gmail.com> wrote:
>
> Use true/false for bool type in bnxt_timer function.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
Thanks.

Acked-by: Michael Chan <michael.chan@broadcom.com>
