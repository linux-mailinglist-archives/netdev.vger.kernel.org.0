Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDB9E7A2B
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387494AbfJ1UfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:35:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40710 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387458AbfJ1UfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:35:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id o49so16628809qta.7
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 13:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Efo1f2iDzab89yA+sJpBeMa4JpkP53h4aTWIEfY85cw=;
        b=Eu9IYt8xgViRRDFospaBzlKHKIoMfhwnphLpwIqOcmKo2agUDJr/zHMu8wRo68Ublf
         w5GMHe845cJ+eqjWt7mRm6i62gpdef1Ru769ylnIMSegRQFNLUMdlaF9wKKSYo5dpnBn
         6xKa4YxCnQGwOic42Kk4PReQomaWv/Ms1fstk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Efo1f2iDzab89yA+sJpBeMa4JpkP53h4aTWIEfY85cw=;
        b=h/MS+cNKWjkLibXkv1r65K7xeTxaQg3hgKQ0SQhffRo8xnsniI6YmLt15WyxO+qiQy
         4Jkdq/fDWPyWzNjFYBwL/B9gu3cXJWUq+k9GiU2MhuWDPA26muub/zEjhxvnla8xdNSE
         EXb7F1tATo+SUHqhRtCYIrUX8p+HhNvUUoKwluf3w9AEC7Y4q7tKPQfit2vBXUOc7hJS
         m3MLr5hm4XJ1Qw8E076PQcb33/F2avCbg1Imm1HtPwU9I4nzdBzAd3NQjcEoQ6Sbby7c
         fUcean72BxBtoKlBTtLHltMDulEftCQPRM3a+3V0VXXGt1OQUxFnVFPhMesSRub35BcR
         VOzw==
X-Gm-Message-State: APjAAAUpJsRgtZx89wIhvj/IZRsvf5rM8bs3ieqdeY0+oyvusrS6oPDg
        OClxeNtgxm31c2HxDiRXIHUVXhyxG9ZJSp1iNcaN8Q==
X-Google-Smtp-Source: APXvYqzfEPeXa4QdRhsiRy5Tut2ccCFAItNf8EJ8CfRyeLcnV0fDD5WDT7hc7+RIs2GMd0jwy8QnAj1es5BG1hfnV9I=
X-Received: by 2002:a0c:8a2d:: with SMTP id 42mr11719339qvt.117.1572294902863;
 Mon, 28 Oct 2019 13:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191028201634.GA29069@saurav>
In-Reply-To: <20191028201634.GA29069@saurav>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 28 Oct 2019 13:34:51 -0700
Message-ID: <CACKFLimJZ0YXGCEBaurUyeWrq1kgUUdL7QQWMVJvMEkWZukgPA@mail.gmail.com>
Subject: Re: [PATCH] broadcom: bnxt: Fix use true/false for bool
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        saurav.girepunje@hotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 1:16 PM Saurav Girepunje
<saurav.girepunje@gmail.com> wrote:
>
> Use true/false for bool type in bnxt_timer function.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Acked-by: Michael Chan <michael.chan@broadcom.com>
