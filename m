Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C1339AB52
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhFCUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhFCUC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5E226140A;
        Thu,  3 Jun 2021 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750441;
        bh=bL91cu6ogtTyGxRPIZri6Ql+FCiu+SF6QSQHbM1zYpU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Tr2eRL2ruuI3sDRg5RflhkOkyV9mFTujf1VRSwWuWzGKIhZvbVCaAxYpgxsOn967z
         NSAD7IYMIoOO8cgexRa8htj5TMa5JoT3Wkv0szF26PJNQMzsXvJWAGYrsny6UgxWOB
         0DSG8won1tshR1VxRhArAz/SO25OQjYrnL5dyQS242aahuCLuEtgIYx6YTOuGDajz0
         VHL9LXHRxKII0rPps4b8g2l1RYIZFPwbgL/Xx11gmnvOpzM53mf3Uy04x4VbkhOV+Z
         glYdnkCOfixzeKFSHUpB7CAwyKWxHMoZF81Ql2bUy103FcIKpKZNrY/s3wN0K43mHs
         i4TDGELShuacg==
Received: by mail-ej1-f51.google.com with SMTP id a11so10323612ejf.3;
        Thu, 03 Jun 2021 13:00:41 -0700 (PDT)
X-Gm-Message-State: AOAM532vyxjdQayA5RHN/BZ3eSM5VLUqqhLnZp8Z0LjUv6v41+SWwB5I
        gzz1Ys23MifmIGCwdrRsLZQ4Ow6jF77dUPl5Hg==
X-Google-Smtp-Source: ABdhPJw+IpYqfuukI2sJnNmANmuAWrENFVxO3xUzzlu0fu/6+LhA82SGF/btdHtPoNYDNnkITP5uV0NhDBINu7IILPI=
X-Received: by 2002:a17:906:1d0a:: with SMTP id n10mr868094ejh.341.1622750440433;
 Thu, 03 Jun 2021 13:00:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1622648507.git.mchehab+huawei@kernel.org>
In-Reply-To: <cover.1622648507.git.mchehab+huawei@kernel.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 3 Jun 2021 15:00:29 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKLwfgj1khYFxTykjaYPjbNRd=Ajr-bfEnNYY0cu0Z18A@mail.gmail.com>
Message-ID: <CAL_JsqKLwfgj1khYFxTykjaYPjbNRd=Ajr-bfEnNYY0cu0Z18A@mail.gmail.com>
Subject: Re: [PATCH 00/12] Fix broken docs references at next-20210602
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Keerthy <j-keerthy@ti.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Rosin <peda@axentia.se>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 10:43 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> There are some broken references at today's linux-next with regards
> to files inside Documentation/.
>
> Address them.

I've finally added this to my automated checks, so now anyone that
breaks this on binding schema patches should get notified (with the
exception of patches not Cc'ed to the DT list).

Rob
