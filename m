Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560DA398F15
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhFBPpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232376AbhFBPpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 11:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7867E6140C;
        Wed,  2 Jun 2021 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622648602;
        bh=0MELa+vkFf8qciInEiANCeWuJgsCWdc+iIN4XgabBlU=;
        h=From:To:Cc:Subject:Date:From;
        b=Ow5ucdX+cLyyshfYKKgUmaN7u1vT8JE6wpcqUKxTUm3f4VAqfL+vN/ipg7eINBHcs
         5myl1FE98NtMXFFNDejrwHifMf/IbOWqgFNtE+klnW+5/PCO4dWEcwpTfDeeVN6Ckn
         JvczV9Y13kiuvQ2CanTKQdGdOzLB1jTQO4uU50i8/+hZ241IyBQ7yZ1+WRb4p5SFpk
         EUvYoaJtuDfi/UdKVyvZWcnoFLquBLPz4d3uwoHmZIEwE+ahs53PrxMsQovuDF6qo9
         sI0gAHsVnC3iacI5pyrpN+81xksmA46ctCWF+HtJhVLTBaKuRBj1aOhgCo0bi3Z0n0
         AK5H0lWSJ7oUA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1loT1b-006XbY-6u; Wed, 02 Jun 2021 17:43:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
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
        Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 00/12] Fix broken docs references at next-20210602
Date:   Wed,  2 Jun 2021 17:43:06 +0200
Message-Id: <cover.1622648507.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some broken references at today's linux-next with regards
to files inside Documentation/.

Address them.

Mauro Carvalho Chehab (12):
  dt-bindings: power: supply: cpcap-battery: update cpcap-battery.yaml
    reference
  dt-bindings: power: supply: cpcap-charger: update cpcap-charger.yaml
    reference
  dt-bindings: soc: ti: update sci-pm-domain.yaml references
  dt-bindings: clock: update ti,sci-clk.yaml references
  dt-bindings: reset: update ti,sci-reset.yaml references
  dt-bindings: iio: io-channel-mux.yaml: fix a typo
  docs: accounting: update delay-accounting.rst reference
  MAINTAINERS: update faraday,ftrtc010.yaml reference
  MAINTAINERS: update marvell,armada-3700-utmi-phy.yaml reference
  MAINTAINERS: update ti,omap-gpio.yaml reference
  MAINTAINERS: update ti,sci.yaml reference
  MAINTAINERS: update nxp,imx8-jpeg.yaml reference

 Documentation/admin-guide/sysctl/kernel.rst      |  2 +-
 .../devicetree/bindings/dma/ti-edma.txt          |  4 ++--
 .../devicetree/bindings/gpio/gpio-davinci.txt    |  2 +-
 .../devicetree/bindings/i2c/i2c-davinci.txt      |  4 ++--
 .../bindings/iio/multiplexer/io-channel-mux.yaml |  2 +-
 .../devicetree/bindings/mfd/motorola-cpcap.txt   |  4 ++--
 .../devicetree/bindings/mmc/ti-omap-hsmmc.txt    |  4 ++--
 .../devicetree/bindings/net/can/c_can.txt        |  4 ++--
 .../bindings/remoteproc/ti,keystone-rproc.txt    |  4 ++--
 .../devicetree/bindings/spi/spi-davinci.txt      |  2 +-
 .../devicetree/bindings/usb/ti,j721e-usb.yaml    |  2 +-
 .../bindings/usb/ti,keystone-dwc3.yaml           |  2 +-
 MAINTAINERS                                      | 16 ++++++++--------
 13 files changed, 26 insertions(+), 26 deletions(-)

-- 
2.31.1


