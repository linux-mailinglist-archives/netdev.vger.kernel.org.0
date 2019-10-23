Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63AE1FE6
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436471AbfJWPsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:48:23 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45191 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403945AbfJWPsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:48:22 -0400
Received: by mail-yw1-f66.google.com with SMTP id x65so7585626ywf.12
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+bPLXp3uH+lzOa3mRl2QPF1Y5236jRkMLviaUv9rnbE=;
        b=q4HmCqW0/a2M7E1P4tgdVU0mBQ3ARY5Ucya3u1P9bZgYcKKr+bEJVm6Lzpq2Vwml56
         6+ib5384A0aGbWS60gCQOkUcRF3BKgTO9pX3z4XHj1AQECj8dgNrHr4l9rxcDKrAs5Ne
         3/+wmXtlrIZXLmovVAubeUmo3TZEioZKL0eSW71IwdJjSS8Ladcf1W+UkYTuJNCSeWtA
         1oPOyPOBj/CjcBe+wpLiD60UOKi/TNA9p/Reic8zk3H8NRZByr01AXaOsx2dN9lDAwlT
         bsFQWMP78m8UvoETB5cAkOsH90X8j7G8nvroZ9Yd2w2O7P+3yWvTgQ38Y7YQ7/Pn8Blv
         c6cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+bPLXp3uH+lzOa3mRl2QPF1Y5236jRkMLviaUv9rnbE=;
        b=bpXKXbI/PiK+RWebr9m0uKLiCeRqByqeGPJQzWHb5i/cafxNJIM9FpR56XogztKea2
         M+XaqIZhpQkQnpnYXRcJvCoKpQPKHwjtX4/BL8GzdgU8blbv//AtAsN7zOEiWu8b9fKt
         hEFh7IuqKUSSye3XQmhIFksLVybe/4lQI+g0b5mSAVk+Akkw46ogm3202USd7HlWppyd
         w7awcV+PXtBQPPZAtqztApRztzDc+MpevJ3VKtLTcCICBUt9xIvQMv/xqMFFpGKFNKmh
         v1eoyLUi3Xl1TTJmQ4vHQigG3PzYOjZeHf0XvVV2FVNfSm0msn0FD1qsm2npjXVzgIwZ
         AbTQ==
X-Gm-Message-State: APjAAAXowFJoqzL2W6tyuwwf2oCRabokFMQcDHNAjyBsAkXkMaA0bZFr
        oHw11Hd+QdImPbCaCiBVhz5QGUyYIFRA1MVCB7Y=
X-Google-Smtp-Source: APXvYqx6e4QVulgH4WsdJu84dAKOMYRdrp1YZGm2SOuX+I7IIRBCX/OKKIKS/rhI8oNQ6m3pJ8q0GDcDChVkeLQ05JU=
X-Received: by 2002:a81:3ac2:: with SMTP id h185mr3553520ywa.510.1571845700518;
 Wed, 23 Oct 2019 08:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 23 Oct 2019 18:48:09 +0300
Message-ID: <CAJ3xEMhMpDqWrn8h_3jmMQaEz_Wt6OAVkh0BNkM6-Re6avhWXQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/9] devlink vdev
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 8:46 PM Yuval Avnery <yuvalav@mellanox.com> wrote:
> This patchset introduces devlink vdev.

> Currently, legacy tools do not provide a comprehensive solution that can
> be used in both SmartNic and non-SmartNic mode.
> Vdev represents a device that exists on the ASIC but is not necessarily
> visible to the kernel.

I assume you refer to a function (e.g Eth VF, NVME) or mediated device (e.g the
sub-functions work by mellanox we presented in netdev 0x13) residing on the
host but not visible to the smart nic, smart... would be good to
clarify that here.

FWIW whatever SW you have on the smart NIC, it will still not be able
to actually provision / PT / map this device to a guest/container before/after
this patch set, and a host SW agent is still needed, agree?

worth explaining what delta/progress this series gets us in this context
(of inability to provision from the smartnic ).

Or.
