Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA184973E7
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 18:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbiAWRxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 12:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbiAWRxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 12:53:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B60C06173D
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 09:53:32 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1nBh2H-0007aG-Mg; Sun, 23 Jan 2022 18:52:17 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nBh28-00BycE-Ac; Sun, 23 Jan 2022 18:52:07 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1nBh26-000tzT-Dk; Sun, 23 Jan 2022 18:52:06 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Mark Brown <broonie@kernel.org>
Cc:     =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Markuss Broks <markuss.broks@gmail.com>,
        Emma Anholt <emma@anholt.net>,
        David Lechner <david@lechnology.com>,
        Kamlesh Gurudasani <kamlesh.gurudasani@gmail.com>,
        =?utf-8?q?Noralf_Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dan Robertson <dan@dlrobertson.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Kent Gustavsson <kent@minoris.se>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Antti Palosaari <crope@iki.fi>,
        Lee Jones <lee.jones@linaro.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        =?utf-8?q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Benson Leung <bleung@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>,
        Helge Deller <deller@gmx.de>,
        James Schulman <james.schulman@cirrus.com>,
        David Rhodes <david.rhodes@cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        =?utf-8?q?Nuno_S=C3=A1?= <nuno.sa@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Alexandru Ardelean <ardeleanalex@gmail.com>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        Gwendal Grignou <gwendal@chromium.org>,
        Cai Huoqing <caihuoqing@baidu.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?utf-8?q?Ronald_Tschal=C3=A4r?= <ronald@innovation.ch>,
        Marco Felsch <m.felsch@pengutronix.de>,
        =?utf-8?q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        Jon Hunter <jonathanh@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Heiko Schocher <hs@denx.de>,
        Fabio Estevam <festevam@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Matt Kline <matt@bitbashing.io>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Yang Shen <shenyang39@huawei.com>,
        dingsenjie <dingsenjie@yulong.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Walle <michael@walle.cc>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Sidong Yang <realwakka@gmail.com>,
        Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>,
        Davidlohr Bueso <dbueso@suse.de>, Claudius Heine <ch@denx.de>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        kernel@pengutronix.de, Noralf Tronnes <notro@tronnes.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@google.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: [PATCH 0/5] spi: make remove callback a void function
Date:   Sun, 23 Jan 2022 18:51:56 +0100
Message-Id: <20220123175201.34839-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=13159; h=from:subject; bh=owUsrJiUxQg0WH9JiyxXcWg2QcQX/yEwEp5ObL2T9n0=; b=owGbwMvMwMV48I9IxdpTbzgZT6slMSS+nbpcuF1aSOHc7VvcKru0ItTvBT39tGSS6+W7Qqqsga+6 XV/1dDIaszAwcjHIiimy1BVpiU2QWPPfrmQJN8wgViaQKQxcnAIwkQJ1DoZJL1o6pbJMnj7jmr4qUS z5cENAvodiUGgJM7vdWk2x1lkXfyiGhedIbP/1ivHDvGRTmXL/wIg7PG/WnKtj3+Cxw3vSTCnTOzOd yi9M2O48eVabWmdxdar48r4nD8SX8C08EDSTi+vRDt+c6nvV3NfNWBp1n+gr+KXecpB0EyurXNg2We Uo48mJf1OlAs7efhjiFRf3rvCxJsfV54c496b3NyuWHJzSmuayo0HlZt6l61nCfqtvRPNVJB6OfXdb hs8hRbB7TVzWu4TqJTmrVkWmKp/49rnOYBtTkkTTztLDU1/M/GPS5CYxR5hB+kNfXS1Xv6L8fpUOs7 C3m3IdIjib3pfmHW2edIvrx04rAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series goal is to change the spi remove callback's return value to void.
After numerous patches nearly all drivers already return 0 unconditionally.
The four first patches in this series convert the remaining three drivers to
return 0, the final patch changes the remove prototype and converts all
implementers.

The driver core doesn't support error handling on remove, the spi core issues
only a very generic warning when a remove callback returns an error. If there
is really the need for a function call that can fail, the driver can issue a
more helpful error message. I didn't find a single driver where returning
an error code and error handling in the spi core would have been helpful.

So change the prototype of the remove function to make it obvious for driver
authors that there is no error handling in the spi core.

The four preparatory patches were already send out, but not yet taken into
next.

Assuming Mark is fine with this change I'd like to have this go in during the
next merge window. I guess we need a tag that can be pulled into trees that add
a new driver in the next cycle. I can provide such a tag, but I'm open to
alternatives.

The patch set survived an allmodconfig build on various archs (arm64 m68k
powerpc riscv s390 sparc64 x86_64) after the following two commits from
next-20220121 were added to fix an unrelated build problem:

        be973481daaa ("pinctrl: thunderbay: rework loops looking for groups names")
        8687999e47d4 ("pinctrl: thunderbay: comment process of building functions a bit")

Best regards
Uwe

Uwe Kleine-König (5):
  staging: fbtft: Fix error path in fbtft_driver_module_init()
  staging: fbtft: Deduplicate driver registration macros
  tpm: st33zp24: Make st33zp24_remove() a void function
  platform/chrome: cros_ec: Make cros_ec_unregister() return void
  spi: make remove callback a void function

 drivers/bus/moxtet.c                          |  4 +-
 drivers/char/tpm/st33zp24/i2c.c               |  5 +-
 drivers/char/tpm/st33zp24/spi.c               |  9 +-
 drivers/char/tpm/st33zp24/st33zp24.c          |  3 +-
 drivers/char/tpm/st33zp24/st33zp24.h          |  2 +-
 drivers/char/tpm/tpm_tis_spi_main.c           |  3 +-
 drivers/clk/clk-lmk04832.c                    |  4 +-
 drivers/gpio/gpio-74x164.c                    |  4 +-
 drivers/gpio/gpio-max3191x.c                  |  4 +-
 drivers/gpio/gpio-max7301.c                   |  4 +-
 drivers/gpio/gpio-mc33880.c                   |  4 +-
 drivers/gpio/gpio-pisosr.c                    |  4 +-
 drivers/gpu/drm/panel/panel-abt-y030xx067a.c  |  4 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9322.c  |  4 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c  |  3 +-
 drivers/gpu/drm/panel/panel-innolux-ej030na.c |  4 +-
 drivers/gpu/drm/panel/panel-lg-lb035q02.c     |  4 +-
 drivers/gpu/drm/panel/panel-lg-lg4573.c       |  4 +-
 drivers/gpu/drm/panel/panel-nec-nl8048hl11.c  |  4 +-
 drivers/gpu/drm/panel/panel-novatek-nt39016.c |  4 +-
 drivers/gpu/drm/panel/panel-samsung-db7430.c  |  3 +-
 drivers/gpu/drm/panel/panel-samsung-ld9040.c  |  4 +-
 drivers/gpu/drm/panel/panel-samsung-s6d27a1.c |  3 +-
 .../gpu/drm/panel/panel-samsung-s6e63m0-spi.c |  3 +-
 .../gpu/drm/panel/panel-sitronix-st7789v.c    |  4 +-
 drivers/gpu/drm/panel/panel-sony-acx565akm.c  |  4 +-
 drivers/gpu/drm/panel/panel-tpo-td028ttec1.c  |  4 +-
 drivers/gpu/drm/panel/panel-tpo-td043mtea1.c  |  4 +-
 drivers/gpu/drm/panel/panel-tpo-tpg110.c      |  3 +-
 .../gpu/drm/panel/panel-widechips-ws2401.c    |  3 +-
 drivers/gpu/drm/tiny/hx8357d.c                |  4 +-
 drivers/gpu/drm/tiny/ili9163.c                |  4 +-
 drivers/gpu/drm/tiny/ili9225.c                |  4 +-
 drivers/gpu/drm/tiny/ili9341.c                |  4 +-
 drivers/gpu/drm/tiny/ili9486.c                |  4 +-
 drivers/gpu/drm/tiny/mi0283qt.c               |  4 +-
 drivers/gpu/drm/tiny/repaper.c                |  4 +-
 drivers/gpu/drm/tiny/st7586.c                 |  4 +-
 drivers/gpu/drm/tiny/st7735r.c                |  4 +-
 drivers/hwmon/adcxx.c                         |  4 +-
 drivers/hwmon/adt7310.c                       |  3 +-
 drivers/hwmon/max1111.c                       |  3 +-
 drivers/hwmon/max31722.c                      |  4 +-
 drivers/iio/accel/bma400_spi.c                |  4 +-
 drivers/iio/accel/bmc150-accel-spi.c          |  4 +-
 drivers/iio/accel/bmi088-accel-spi.c          |  4 +-
 drivers/iio/accel/kxsd9-spi.c                 |  4 +-
 drivers/iio/accel/mma7455_spi.c               |  4 +-
 drivers/iio/accel/sca3000.c                   |  4 +-
 drivers/iio/adc/ad7266.c                      |  4 +-
 drivers/iio/adc/ltc2496.c                     |  4 +-
 drivers/iio/adc/mcp320x.c                     |  4 +-
 drivers/iio/adc/mcp3911.c                     |  4 +-
 drivers/iio/adc/ti-adc12138.c                 |  4 +-
 drivers/iio/adc/ti-ads7950.c                  |  4 +-
 drivers/iio/adc/ti-ads8688.c                  |  4 +-
 drivers/iio/adc/ti-tlc4541.c                  |  4 +-
 drivers/iio/amplifiers/ad8366.c               |  4 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c      |  4 +-
 drivers/iio/dac/ad5360.c                      |  4 +-
 drivers/iio/dac/ad5380.c                      |  4 +-
 drivers/iio/dac/ad5446.c                      |  4 +-
 drivers/iio/dac/ad5449.c                      |  4 +-
 drivers/iio/dac/ad5504.c                      |  4 +-
 drivers/iio/dac/ad5592r.c                     |  4 +-
 drivers/iio/dac/ad5624r_spi.c                 |  4 +-
 drivers/iio/dac/ad5686-spi.c                  |  4 +-
 drivers/iio/dac/ad5761.c                      |  4 +-
 drivers/iio/dac/ad5764.c                      |  4 +-
 drivers/iio/dac/ad5791.c                      |  4 +-
 drivers/iio/dac/ad8801.c                      |  4 +-
 drivers/iio/dac/ltc1660.c                     |  4 +-
 drivers/iio/dac/ltc2632.c                     |  4 +-
 drivers/iio/dac/mcp4922.c                     |  4 +-
 drivers/iio/dac/ti-dac082s085.c               |  4 +-
 drivers/iio/dac/ti-dac7311.c                  |  3 +-
 drivers/iio/frequency/adf4350.c               |  4 +-
 drivers/iio/gyro/bmg160_spi.c                 |  4 +-
 drivers/iio/gyro/fxas21002c_spi.c             |  4 +-
 drivers/iio/health/afe4403.c                  |  4 +-
 drivers/iio/magnetometer/bmc150_magn_spi.c    |  4 +-
 drivers/iio/magnetometer/hmc5843_spi.c        |  4 +-
 drivers/iio/potentiometer/max5487.c           |  4 +-
 drivers/iio/pressure/ms5611_spi.c             |  4 +-
 drivers/iio/pressure/zpa2326_spi.c            |  4 +-
 drivers/input/keyboard/applespi.c             |  4 +-
 drivers/input/misc/adxl34x-spi.c              |  4 +-
 drivers/input/touchscreen/ads7846.c           |  4 +-
 drivers/input/touchscreen/cyttsp4_spi.c       |  4 +-
 drivers/input/touchscreen/tsc2005.c           |  4 +-
 drivers/leds/leds-cr0014114.c                 |  4 +-
 drivers/leds/leds-dac124s085.c                |  4 +-
 drivers/leds/leds-el15203000.c                |  4 +-
 drivers/leds/leds-spi-byte.c                  |  4 +-
 drivers/media/spi/cxd2880-spi.c               |  4 +-
 drivers/media/spi/gs1662.c                    |  4 +-
 drivers/media/tuners/msi001.c                 |  3 +-
 drivers/mfd/arizona-spi.c                     |  4 +-
 drivers/mfd/da9052-spi.c                      |  3 +-
 drivers/mfd/ezx-pcap.c                        |  4 +-
 drivers/mfd/madera-spi.c                      |  4 +-
 drivers/mfd/mc13xxx-spi.c                     |  3 +-
 drivers/mfd/rsmu_spi.c                        |  4 +-
 drivers/mfd/stmpe-spi.c                       |  4 +-
 drivers/mfd/tps65912-spi.c                    |  4 +-
 drivers/misc/ad525x_dpot-spi.c                |  3 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |  4 +-
 drivers/misc/lattice-ecp3-config.c            |  4 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c        |  4 +-
 drivers/mmc/host/mmc_spi.c                    |  3 +-
 drivers/mtd/devices/mchp23k256.c              |  4 +-
 drivers/mtd/devices/mchp48l640.c              |  4 +-
 drivers/mtd/devices/mtd_dataflash.c           |  4 +-
 drivers/mtd/devices/sst25l.c                  |  4 +-
 drivers/net/can/m_can/tcan4x5x-core.c         |  4 +-
 drivers/net/can/spi/hi311x.c                  |  4 +-
 drivers/net/can/spi/mcp251x.c                 |  4 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    |  4 +-
 drivers/net/dsa/b53/b53_spi.c                 |  4 +-
 drivers/net/dsa/microchip/ksz8795_spi.c       |  4 +-
 drivers/net/dsa/microchip/ksz9477_spi.c       |  4 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  6 +-
 drivers/net/dsa/vitesse-vsc73xx-spi.c         |  6 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  4 +-
 drivers/net/ethernet/micrel/ks8851_spi.c      |  4 +-
 drivers/net/ethernet/microchip/enc28j60.c     |  4 +-
 drivers/net/ethernet/microchip/encx24j600.c   |  4 +-
 drivers/net/ethernet/qualcomm/qca_spi.c       |  4 +-
 drivers/net/ethernet/vertexcom/mse102x.c      |  4 +-
 drivers/net/ethernet/wiznet/w5100-spi.c       |  4 +-
 drivers/net/ieee802154/adf7242.c              |  4 +-
 drivers/net/ieee802154/at86rf230.c            |  4 +-
 drivers/net/ieee802154/ca8210.c               |  6 +-
 drivers/net/ieee802154/cc2520.c               |  4 +-
 drivers/net/ieee802154/mcr20a.c               |  4 +-
 drivers/net/ieee802154/mrf24j40.c             |  4 +-
 drivers/net/phy/spi_ks8995.c                  |  4 +-
 drivers/net/wan/slic_ds26522.c                |  3 +-
 drivers/net/wireless/intersil/p54/p54spi.c    |  4 +-
 .../net/wireless/marvell/libertas/if_spi.c    |  4 +-
 drivers/net/wireless/microchip/wilc1000/spi.c |  4 +-
 drivers/net/wireless/st/cw1200/cw1200_spi.c   |  4 +-
 drivers/net/wireless/ti/wl1251/spi.c          |  4 +-
 drivers/net/wireless/ti/wlcore/spi.c          |  4 +-
 drivers/nfc/nfcmrvl/spi.c                     |  3 +-
 drivers/nfc/st-nci/spi.c                      |  4 +-
 drivers/nfc/st95hf/core.c                     |  4 +-
 drivers/nfc/trf7970a.c                        |  4 +-
 drivers/platform/chrome/cros_ec.c             |  4 +-
 drivers/platform/chrome/cros_ec.h             |  2 +-
 drivers/platform/chrome/cros_ec_i2c.c         |  4 +-
 drivers/platform/chrome/cros_ec_lpc.c         |  4 +-
 drivers/platform/chrome/cros_ec_spi.c         |  4 +-
 drivers/platform/olpc/olpc-xo175-ec.c         |  4 +-
 drivers/rtc/rtc-ds1302.c                      |  3 +-
 drivers/rtc/rtc-ds1305.c                      |  4 +-
 drivers/rtc/rtc-ds1343.c                      |  4 +-
 drivers/spi/spi-mem.c                         |  6 +-
 drivers/spi/spi-slave-system-control.c        |  3 +-
 drivers/spi/spi-slave-time.c                  |  3 +-
 drivers/spi/spi-tle62x0.c                     |  3 +-
 drivers/spi/spi.c                             | 11 +--
 drivers/spi/spidev.c                          |  4 +-
 drivers/staging/fbtft/fbtft.h                 | 97 ++++++++-----------
 drivers/staging/pi433/pi433_if.c              |  4 +-
 drivers/staging/wfx/bus_spi.c                 |  3 +-
 drivers/tty/serial/max3100.c                  |  5 +-
 drivers/tty/serial/max310x.c                  |  3 +-
 drivers/tty/serial/sc16is7xx.c                |  4 +-
 drivers/usb/gadget/udc/max3420_udc.c          |  4 +-
 drivers/usb/host/max3421-hcd.c                |  3 +-
 drivers/video/backlight/ams369fg06.c          |  3 +-
 drivers/video/backlight/corgi_lcd.c           |  3 +-
 drivers/video/backlight/ili922x.c             |  3 +-
 drivers/video/backlight/l4f00242t03.c         |  3 +-
 drivers/video/backlight/lms501kf03.c          |  3 +-
 drivers/video/backlight/ltv350qv.c            |  3 +-
 drivers/video/backlight/tdo24m.c              |  3 +-
 drivers/video/backlight/tosa_lcd.c            |  4 +-
 drivers/video/backlight/vgg2432a4.c           |  4 +-
 drivers/video/fbdev/omap/lcd_mipid.c          |  4 +-
 .../displays/panel-lgphilips-lb035q02.c       |  4 +-
 .../omapfb/displays/panel-nec-nl8048hl11.c    |  4 +-
 .../omapfb/displays/panel-sony-acx565akm.c    |  4 +-
 .../omapfb/displays/panel-tpo-td028ttec1.c    |  4 +-
 .../omapfb/displays/panel-tpo-td043mtea1.c    |  4 +-
 include/linux/spi/spi.h                       |  2 +-
 sound/pci/hda/cs35l41_hda_spi.c               |  4 +-
 sound/soc/codecs/adau1761-spi.c               |  3 +-
 sound/soc/codecs/adau1781-spi.c               |  3 +-
 sound/soc/codecs/cs35l41-spi.c                |  4 +-
 sound/soc/codecs/pcm3168a-spi.c               |  4 +-
 sound/soc/codecs/pcm512x-spi.c                |  3 +-
 sound/soc/codecs/tlv320aic32x4-spi.c          |  4 +-
 sound/soc/codecs/tlv320aic3x-spi.c            |  4 +-
 sound/soc/codecs/wm0010.c                     |  4 +-
 sound/soc/codecs/wm8804-spi.c                 |  3 +-
 sound/spi/at73c213.c                          |  4 +-
 198 files changed, 248 insertions(+), 617 deletions(-)


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.34.1

