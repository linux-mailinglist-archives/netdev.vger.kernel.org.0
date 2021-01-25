Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EDE304ADE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbhAZEzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:55:54 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52389 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbhAYKT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:19:56 -0500
Received: from cust-b5b5937f ([IPv6:fc0c:c16d:66b8:757f:c639:739b:9d66:799d])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 3yXTlSvhoiWRg3yXWlfjtk; Mon, 25 Jan 2021 10:52:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s2;
        t=1611568334; bh=4/1xAWs2pABuJ7a3pBbnAwc4fjuMRjTRD6WNjjHXvTY=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=FojMbt+R8NxSewprNZEE1InMgYwJmZhmHE3W/5ewP+2nKtZ5jcCUeuph1MGvT5clQ
         LlK60x9AI3wn5+EPix/oY+dIxI+ku+Uw9v8jWzndzZ0QBVluME8JOVXHLxKNavzY12
         5m66JYpNBZzCpUgyqrvsv4z+xD+F2EvDO021lHaCB22IPCxCL0JPiiSHI98icHkYQ8
         VZx0FqO1Ejg11eR3fdcHZR4ME6PMU5xbq3YQ9zoAUj2594SX6WH12WiVRIuyYKl/hj
         ma3okY9mjMWY4rDDvL9Z9m15c7tTVczTy33GBV+C+f8Qp2jGN8BsR5JdUc5riWXOWf
         Kl/9xbH+/wDxw==
Subject: Re: [PATCH v2 3/3] isa: Make the remove callback for isa drivers
 return void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org, Wolfram Sang <wsa@kernel.org>,
        Takashi Iway <tiwai@suse.de>
References: <20210122092449.426097-1-uwe@kleine-koenig.org>
 <20210122092449.426097-4-uwe@kleine-koenig.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8b109181-6bee-b83f-020a-8190a6129c43@xs4all.nl>
Date:   Mon, 25 Jan 2021 10:52:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210122092449.426097-4-uwe@kleine-koenig.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIsOsWUSPZxSOG7M/iSRoFOTbW93WtOMTZPIUjN11fvvWLHXAoW4XMyYlGRHzL60V9TfD9JqQLpEEdqrsw40xpEVUvH8i7Mb6oDbHTQjwIs8y7TKNAuP
 TTp/ZhL6uauL2Dgl0MSfn8retoNZRgJtMG4gtQXU+pLucyuTuF7jv0xaykT01WcWQEErCFSjjIvkbpK/sXaD3+oCSg925xYZdQjnNfhWpI2Xr49J6cNx6X4G
 TELTwOrUlDlRr8qqmwY6mnPH0N3B5iGqNKjJr8rcpii1DpXaOC4xI1yTI2R1828rbXPWvb3zsJRFpbxrHdqIh5hZjrdIT4UtV0k16/gXPanbuFsONvWpJ6TC
 3cESesMf23GEi/U1Ks9wINeUi1pw6XSu0kZ/m7nXAaQCciLpAHzZlhYLQDHvhyKlgX4iZhCpLnGIqKMppOVwef67oOeifCvrfAhxBoeACI31lVpQE9tApvyj
 cKr0yU7IlAuIa2Rt9UeF+Lu8dIFpAKKeMyFZjsBRwmmoxgtOZcpE6BQw5k4peFSx+E+jk9QeYqdZh+ujtDqvGNm9SZ3uW7tvQwm699ro+/QOYJ9JOJlVsGaK
 zSdWFIncjYS3EQA2yTKNS2zVNK4as17UmrEh6JwtziUf0kML3+qzI+LV01SCQreSGuibci6OE5KIot8fTqqZQx7APdWihAg3kNGkf+cJIPyGXLsINwQzReot
 M7P2XoOX4NT0sPrtNukByAcLmkLEZQM5onfPkvTmvbM6/876vbuysUeRTfYY3u3KxgE3P3mKIiEvqL9JxLKWDL5MI4Zqhf+V46cze/fhihVUPC7SeF7gWrRM
 glKOaRoj4pnkUhzcFEibzVMS+7zU3VmdmLd2joRadGwJH9SUIlvQWzE7Ss6SqcE7aX1O4UzCC3wdd+NAM9OT7G+IfXoBIoEXPcfDP5dYiJo8p/0wrhDSzkbe
 V2y7SW0b4HvBJgb1GiXFGKsDe9CS8eChKb8RNSM4IrkUUjTNAtbkEG+ajnAlA9pMTPZo1FzY58GgVnYfS/LM+MApT6ysSg8KuUQfHapFZJlsQuZA+qKklinc
 eC6bJfFh66rWORjWEXiDDEB4etEaxbdjmCBtV7hrguJZ6JdHeeJ9cBFMpzmf0ONHkyRqJgKLd60rXvuStBxnkKfhl9yLPE7RnHVa9U70CaoiPhXZ5qUIut5k
 ifr395ovdWjwycL+4nxRCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/01/2021 10:24, Uwe Kleine-König wrote:
> The driver core ignores the return value of the remove callback, so
> don't give isa drivers the chance to provide a value.
> 
> Adapt all isa_drivers with a remove callbacks accordingly; they all
> return 0 unconditionally anyhow.
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for drivers/net/can/sja1000/tscan1.c
> Acked-by: William Breathitt Gray <vilhelm.gray@gmail.com>
> Acked-by: Wolfram Sang <wsa@kernel.org> # for drivers/i2c/
> Reviewed-by: Takashi Iway <tiwai@suse.de> # for sound/
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

For the media/radio drivers:

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks,

	Hans

> ---
>  drivers/base/isa.c                   | 2 +-
>  drivers/i2c/busses/i2c-elektor.c     | 4 +---
>  drivers/i2c/busses/i2c-pca-isa.c     | 4 +---
>  drivers/input/touchscreen/htcpen.c   | 4 +---
>  drivers/media/radio/radio-isa.c      | 4 +---
>  drivers/media/radio/radio-isa.h      | 2 +-
>  drivers/media/radio/radio-sf16fmr2.c | 4 +---
>  drivers/net/can/sja1000/tscan1.c     | 4 +---
>  drivers/net/ethernet/3com/3c509.c    | 3 +--
>  drivers/scsi/advansys.c              | 3 +--
>  drivers/scsi/aha1542.c               | 3 +--
>  drivers/scsi/fdomain_isa.c           | 3 +--
>  drivers/scsi/g_NCR5380.c             | 5 ++---
>  drivers/watchdog/pcwd.c              | 4 +---
>  include/linux/isa.h                  | 2 +-
>  sound/isa/ad1848/ad1848.c            | 3 +--
>  sound/isa/adlib.c                    | 3 +--
>  sound/isa/cmi8328.c                  | 3 +--
>  sound/isa/cmi8330.c                  | 3 +--
>  sound/isa/cs423x/cs4231.c            | 3 +--
>  sound/isa/cs423x/cs4236.c            | 3 +--
>  sound/isa/es1688/es1688.c            | 3 +--
>  sound/isa/es18xx.c                   | 5 ++---
>  sound/isa/galaxy/galaxy.c            | 3 +--
>  sound/isa/gus/gusclassic.c           | 3 +--
>  sound/isa/gus/gusextreme.c           | 3 +--
>  sound/isa/gus/gusmax.c               | 3 +--
>  sound/isa/gus/interwave.c            | 3 +--
>  sound/isa/msnd/msnd_pinnacle.c       | 3 +--
>  sound/isa/opl3sa2.c                  | 3 +--
>  sound/isa/opti9xx/miro.c             | 3 +--
>  sound/isa/opti9xx/opti92x-ad1848.c   | 5 ++---
>  sound/isa/sb/jazz16.c                | 3 +--
>  sound/isa/sb/sb16.c                  | 3 +--
>  sound/isa/sb/sb8.c                   | 3 +--
>  sound/isa/sc6000.c                   | 3 +--
>  sound/isa/sscape.c                   | 3 +--
>  sound/isa/wavefront/wavefront.c      | 3 +--
>  38 files changed, 41 insertions(+), 83 deletions(-)
> 
> diff --git a/drivers/base/isa.c b/drivers/base/isa.c
> index 2772f5d1948a..aa4737667026 100644
> --- a/drivers/base/isa.c
> +++ b/drivers/base/isa.c
> @@ -51,7 +51,7 @@ static int isa_bus_remove(struct device *dev)
>  	struct isa_driver *isa_driver = dev->platform_data;
>  
>  	if (isa_driver && isa_driver->remove)
> -		return isa_driver->remove(dev, to_isa_dev(dev)->id);
> +		isa_driver->remove(dev, to_isa_dev(dev)->id);
>  
>  	return 0;
>  }
> diff --git a/drivers/i2c/busses/i2c-elektor.c b/drivers/i2c/busses/i2c-elektor.c
> index 140426db28df..b72a3c3ef2ab 100644
> --- a/drivers/i2c/busses/i2c-elektor.c
> +++ b/drivers/i2c/busses/i2c-elektor.c
> @@ -282,7 +282,7 @@ static int elektor_probe(struct device *dev, unsigned int id)
>  	return -ENODEV;
>  }
>  
> -static int elektor_remove(struct device *dev, unsigned int id)
> +static void elektor_remove(struct device *dev, unsigned int id)
>  {
>  	i2c_del_adapter(&pcf_isa_ops);
>  
> @@ -298,8 +298,6 @@ static int elektor_remove(struct device *dev, unsigned int id)
>  		iounmap(base_iomem);
>  		release_mem_region(base, 2);
>  	}
> -
> -	return 0;
>  }
>  
>  static struct isa_driver i2c_elektor_driver = {
> diff --git a/drivers/i2c/busses/i2c-pca-isa.c b/drivers/i2c/busses/i2c-pca-isa.c
> index f27bc1e55385..85e8cf58e8bf 100644
> --- a/drivers/i2c/busses/i2c-pca-isa.c
> +++ b/drivers/i2c/busses/i2c-pca-isa.c
> @@ -161,7 +161,7 @@ static int pca_isa_probe(struct device *dev, unsigned int id)
>  	return -ENODEV;
>  }
>  
> -static int pca_isa_remove(struct device *dev, unsigned int id)
> +static void pca_isa_remove(struct device *dev, unsigned int id)
>  {
>  	i2c_del_adapter(&pca_isa_ops);
>  
> @@ -170,8 +170,6 @@ static int pca_isa_remove(struct device *dev, unsigned int id)
>  		free_irq(irq, &pca_isa_ops);
>  	}
>  	release_region(base, IO_SIZE);
> -
> -	return 0;
>  }
>  
>  static struct isa_driver pca_isa_driver = {
> diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
> index 2f261a34f9c2..056ba76087e8 100644
> --- a/drivers/input/touchscreen/htcpen.c
> +++ b/drivers/input/touchscreen/htcpen.c
> @@ -171,7 +171,7 @@ static int htcpen_isa_probe(struct device *dev, unsigned int id)
>  	return err;
>  }
>  
> -static int htcpen_isa_remove(struct device *dev, unsigned int id)
> +static void htcpen_isa_remove(struct device *dev, unsigned int id)
>  {
>  	struct input_dev *htcpen_dev = dev_get_drvdata(dev);
>  
> @@ -182,8 +182,6 @@ static int htcpen_isa_remove(struct device *dev, unsigned int id)
>  	release_region(HTCPEN_PORT_INDEX, 2);
>  	release_region(HTCPEN_PORT_INIT, 1);
>  	release_region(HTCPEN_PORT_IRQ_CLEAR, 1);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
> index 527f4c3b0ca4..c591c0851fa2 100644
> --- a/drivers/media/radio/radio-isa.c
> +++ b/drivers/media/radio/radio-isa.c
> @@ -337,13 +337,11 @@ int radio_isa_probe(struct device *pdev, unsigned int dev)
>  }
>  EXPORT_SYMBOL_GPL(radio_isa_probe);
>  
> -int radio_isa_remove(struct device *pdev, unsigned int dev)
> +void radio_isa_remove(struct device *pdev, unsigned int dev)
>  {
>  	struct radio_isa_card *isa = dev_get_drvdata(pdev);
>  
>  	radio_isa_common_remove(isa, isa->drv->region_size);
> -
> -	return 0;
>  }
>  EXPORT_SYMBOL_GPL(radio_isa_remove);
>  
> diff --git a/drivers/media/radio/radio-isa.h b/drivers/media/radio/radio-isa.h
> index 2f0736edfda8..c9159958203e 100644
> --- a/drivers/media/radio/radio-isa.h
> +++ b/drivers/media/radio/radio-isa.h
> @@ -91,7 +91,7 @@ struct radio_isa_driver {
>  
>  int radio_isa_match(struct device *pdev, unsigned int dev);
>  int radio_isa_probe(struct device *pdev, unsigned int dev);
> -int radio_isa_remove(struct device *pdev, unsigned int dev);
> +void radio_isa_remove(struct device *pdev, unsigned int dev);
>  #ifdef CONFIG_PNP
>  int radio_isa_pnp_probe(struct pnp_dev *dev,
>  			const struct pnp_device_id *dev_id);
> diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
> index 0388894cfe41..d0dde55b7930 100644
> --- a/drivers/media/radio/radio-sf16fmr2.c
> +++ b/drivers/media/radio/radio-sf16fmr2.c
> @@ -293,11 +293,9 @@ static void fmr2_remove(struct fmr2 *fmr2)
>  	kfree(fmr2);
>  }
>  
> -static int fmr2_isa_remove(struct device *pdev, unsigned int ndev)
> +static void fmr2_isa_remove(struct device *pdev, unsigned int ndev)
>  {
>  	fmr2_remove(dev_get_drvdata(pdev));
> -
> -	return 0;
>  }
>  
>  static void fmr2_pnp_remove(struct pnp_dev *pdev)
> diff --git a/drivers/net/can/sja1000/tscan1.c b/drivers/net/can/sja1000/tscan1.c
> index 6ea802c66124..3dbba8d61afb 100644
> --- a/drivers/net/can/sja1000/tscan1.c
> +++ b/drivers/net/can/sja1000/tscan1.c
> @@ -159,7 +159,7 @@ static int tscan1_probe(struct device *dev, unsigned id)
>  	return -ENXIO;
>  }
>  
> -static int tscan1_remove(struct device *dev, unsigned id /*unused*/)
> +static void tscan1_remove(struct device *dev, unsigned id /*unused*/)
>  {
>  	struct net_device *netdev;
>  	struct sja1000_priv *priv;
> @@ -179,8 +179,6 @@ static int tscan1_remove(struct device *dev, unsigned id /*unused*/)
>  	release_region(pld_base, TSCAN1_PLD_SIZE);
>  
>  	free_sja1000dev(netdev);
> -
> -	return 0;
>  }
>  
>  static struct isa_driver tscan1_isa_driver = {
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
> index 667f38c9e4c6..53e1f7e07959 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -335,12 +335,11 @@ static int el3_isa_match(struct device *pdev, unsigned int ndev)
>  	return 1;
>  }
>  
> -static int el3_isa_remove(struct device *pdev,
> +static void el3_isa_remove(struct device *pdev,
>  				    unsigned int ndev)
>  {
>  	el3_device_remove(pdev);
>  	dev_set_drvdata(pdev, NULL);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 79830e77afa9..b1e97f75b0ba 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -11459,12 +11459,11 @@ static int advansys_isa_probe(struct device *dev, unsigned int id)
>  	return err;
>  }
>  
> -static int advansys_isa_remove(struct device *dev, unsigned int id)
> +static void advansys_isa_remove(struct device *dev, unsigned int id)
>  {
>  	int ioport = _asc_def_iop_base[id];
>  	advansys_release(dev_get_drvdata(dev));
>  	release_region(ioport, ASC_IOADR_GAP);
> -	return 0;
>  }
>  
>  static struct isa_driver advansys_isa_driver = {
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index dc5667afeb27..e0d8cca1c70b 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -1025,12 +1025,11 @@ static int aha1542_isa_match(struct device *pdev, unsigned int ndev)
>  	return 1;
>  }
>  
> -static int aha1542_isa_remove(struct device *pdev,
> +static void aha1542_isa_remove(struct device *pdev,
>  				    unsigned int ndev)
>  {
>  	aha1542_release(dev_get_drvdata(pdev));
>  	dev_set_drvdata(pdev, NULL);
> -	return 0;
>  }
>  
>  static struct isa_driver aha1542_isa_driver = {
> diff --git a/drivers/scsi/fdomain_isa.c b/drivers/scsi/fdomain_isa.c
> index e0cdcd2003d0..2b4280a43a53 100644
> --- a/drivers/scsi/fdomain_isa.c
> +++ b/drivers/scsi/fdomain_isa.c
> @@ -175,7 +175,7 @@ static int fdomain_isa_param_match(struct device *dev, unsigned int ndev)
>  	return 1;
>  }
>  
> -static int fdomain_isa_remove(struct device *dev, unsigned int ndev)
> +static void fdomain_isa_remove(struct device *dev, unsigned int ndev)
>  {
>  	struct Scsi_Host *sh = dev_get_drvdata(dev);
>  	int base = sh->io_port;
> @@ -183,7 +183,6 @@ static int fdomain_isa_remove(struct device *dev, unsigned int ndev)
>  	fdomain_destroy(sh);
>  	release_region(base, FDOMAIN_REGION_SIZE);
>  	dev_set_drvdata(dev, NULL);
> -	return 0;
>  }
>  
>  static struct isa_driver fdomain_isa_driver = {
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 2df2f38a9b12..7ba3c9312731 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -720,12 +720,11 @@ static int generic_NCR5380_isa_match(struct device *pdev, unsigned int ndev)
>  	return 1;
>  }
>  
> -static int generic_NCR5380_isa_remove(struct device *pdev,
> -                                      unsigned int ndev)
> +static void generic_NCR5380_isa_remove(struct device *pdev,
> +				       unsigned int ndev)
>  {
>  	generic_NCR5380_release_resources(dev_get_drvdata(pdev));
>  	dev_set_drvdata(pdev, NULL);
> -	return 0;
>  }
>  
>  static struct isa_driver generic_NCR5380_isa_driver = {
> diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
> index b95cd38f3ceb..a793b03a785d 100644
> --- a/drivers/watchdog/pcwd.c
> +++ b/drivers/watchdog/pcwd.c
> @@ -951,7 +951,7 @@ static int pcwd_isa_probe(struct device *dev, unsigned int id)
>  	return ret;
>  }
>  
> -static int pcwd_isa_remove(struct device *dev, unsigned int id)
> +static void pcwd_isa_remove(struct device *dev, unsigned int id)
>  {
>  	if (debug >= DEBUG)
>  		pr_debug("pcwd_isa_remove id=%d\n", id);
> @@ -968,8 +968,6 @@ static int pcwd_isa_remove(struct device *dev, unsigned int id)
>  			(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
>  	pcwd_private.io_addr = 0x0000;
>  	cards_found--;
> -
> -	return 0;
>  }
>  
>  static void pcwd_isa_shutdown(struct device *dev, unsigned int id)
> diff --git a/include/linux/isa.h b/include/linux/isa.h
> index 41336da0f4e7..e30963190968 100644
> --- a/include/linux/isa.h
> +++ b/include/linux/isa.h
> @@ -13,7 +13,7 @@
>  struct isa_driver {
>  	int (*match)(struct device *, unsigned int);
>  	int (*probe)(struct device *, unsigned int);
> -	int (*remove)(struct device *, unsigned int);
> +	void (*remove)(struct device *, unsigned int);
>  	void (*shutdown)(struct device *, unsigned int);
>  	int (*suspend)(struct device *, unsigned int, pm_message_t);
>  	int (*resume)(struct device *, unsigned int);
> diff --git a/sound/isa/ad1848/ad1848.c b/sound/isa/ad1848/ad1848.c
> index 593c6e959afe..48f7cc57c3da 100644
> --- a/sound/isa/ad1848/ad1848.c
> +++ b/sound/isa/ad1848/ad1848.c
> @@ -118,10 +118,9 @@ out:	snd_card_free(card);
>  	return error;
>  }
>  
> -static int snd_ad1848_remove(struct device *dev, unsigned int n)
> +static void snd_ad1848_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/adlib.c b/sound/isa/adlib.c
> index 5105524b6f38..e6cd7c4da38e 100644
> --- a/sound/isa/adlib.c
> +++ b/sound/isa/adlib.c
> @@ -97,10 +97,9 @@ out:	snd_card_free(card);
>  	return error;
>  }
>  
> -static int snd_adlib_remove(struct device *dev, unsigned int n)
> +static void snd_adlib_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_adlib_driver = {
> diff --git a/sound/isa/cmi8328.c b/sound/isa/cmi8328.c
> index faca5dd95bfe..3b9fbb02864b 100644
> --- a/sound/isa/cmi8328.c
> +++ b/sound/isa/cmi8328.c
> @@ -403,7 +403,7 @@ static int snd_cmi8328_probe(struct device *pdev, unsigned int ndev)
>  	return err;
>  }
>  
> -static int snd_cmi8328_remove(struct device *pdev, unsigned int dev)
> +static void snd_cmi8328_remove(struct device *pdev, unsigned int dev)
>  {
>  	struct snd_card *card = dev_get_drvdata(pdev);
>  	struct snd_cmi8328 *cmi = card->private_data;
> @@ -420,7 +420,6 @@ static int snd_cmi8328_remove(struct device *pdev, unsigned int dev)
>  	snd_cmi8328_cfg_write(cmi->port, CFG2, 0);
>  	snd_cmi8328_cfg_write(cmi->port, CFG3, 0);
>  	snd_card_free(card);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
> index 4669eb0cc8ce..19e258527d69 100644
> --- a/sound/isa/cmi8330.c
> +++ b/sound/isa/cmi8330.c
> @@ -631,11 +631,10 @@ static int snd_cmi8330_isa_probe(struct device *pdev,
>  	return 0;
>  }
>  
> -static int snd_cmi8330_isa_remove(struct device *devptr,
> +static void snd_cmi8330_isa_remove(struct device *devptr,
>  				  unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
> index 2135963eba78..383ee621cea1 100644
> --- a/sound/isa/cs423x/cs4231.c
> +++ b/sound/isa/cs423x/cs4231.c
> @@ -135,10 +135,9 @@ out:	snd_card_free(card);
>  	return error;
>  }
>  
> -static int snd_cs4231_remove(struct device *dev, unsigned int n)
> +static void snd_cs4231_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
> index fa3c39cff5f8..24688271e73f 100644
> --- a/sound/isa/cs423x/cs4236.c
> +++ b/sound/isa/cs423x/cs4236.c
> @@ -487,11 +487,10 @@ static int snd_cs423x_isa_probe(struct device *pdev,
>  	return 0;
>  }
>  
> -static int snd_cs423x_isa_remove(struct device *pdev,
> +static void snd_cs423x_isa_remove(struct device *pdev,
>  				 unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(pdev));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
> index 64610571a5e1..d99bb3f8f0c1 100644
> --- a/sound/isa/es1688/es1688.c
> +++ b/sound/isa/es1688/es1688.c
> @@ -192,10 +192,9 @@ static int snd_es1688_isa_probe(struct device *dev, unsigned int n)
>  	return error;
>  }
>  
> -static int snd_es1688_isa_remove(struct device *dev, unsigned int n)
> +static void snd_es1688_isa_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_es1688_driver = {
> diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
> index 5f8d7e8a5477..9beef8079177 100644
> --- a/sound/isa/es18xx.c
> +++ b/sound/isa/es18xx.c
> @@ -2210,11 +2210,10 @@ static int snd_es18xx_isa_probe(struct device *pdev, unsigned int dev)
>  	}
>  }
>  
> -static int snd_es18xx_isa_remove(struct device *devptr,
> -				 unsigned int dev)
> +static void snd_es18xx_isa_remove(struct device *devptr,
> +				  unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
> index 65f9f46c9f58..d33d69f29924 100644
> --- a/sound/isa/galaxy/galaxy.c
> +++ b/sound/isa/galaxy/galaxy.c
> @@ -608,10 +608,9 @@ static int snd_galaxy_probe(struct device *dev, unsigned int n)
>  	return err;
>  }
>  
> -static int snd_galaxy_remove(struct device *dev, unsigned int n)
> +static void snd_galaxy_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_galaxy_driver = {
> diff --git a/sound/isa/gus/gusclassic.c b/sound/isa/gus/gusclassic.c
> index 7419b1939754..015f88a11352 100644
> --- a/sound/isa/gus/gusclassic.c
> +++ b/sound/isa/gus/gusclassic.c
> @@ -195,10 +195,9 @@ out:	snd_card_free(card);
>  	return error;
>  }
>  
> -static int snd_gusclassic_remove(struct device *dev, unsigned int n)
> +static void snd_gusclassic_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_gusclassic_driver = {
> diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
> index ed2f9d64efae..c9f31b4fb887 100644
> --- a/sound/isa/gus/gusextreme.c
> +++ b/sound/isa/gus/gusextreme.c
> @@ -324,10 +324,9 @@ out:	snd_card_free(card);
>  	return error;
>  }
>  
> -static int snd_gusextreme_remove(struct device *dev, unsigned int n)
> +static void snd_gusextreme_remove(struct device *dev, unsigned int n)
>  {
>  	snd_card_free(dev_get_drvdata(dev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_gusextreme_driver = {
> diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
> index 05cd9be4dd8a..dc09fbd6f88d 100644
> --- a/sound/isa/gus/gusmax.c
> +++ b/sound/isa/gus/gusmax.c
> @@ -338,10 +338,9 @@ static int snd_gusmax_probe(struct device *pdev, unsigned int dev)
>  	return err;
>  }
>  
> -static int snd_gusmax_remove(struct device *devptr, unsigned int dev)
> +static void snd_gusmax_remove(struct device *devptr, unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #define DEV_NAME "gusmax"
> diff --git a/sound/isa/gus/interwave.c b/sound/isa/gus/interwave.c
> index 3e9ad930deae..e4d412e72b75 100644
> --- a/sound/isa/gus/interwave.c
> +++ b/sound/isa/gus/interwave.c
> @@ -825,10 +825,9 @@ static int snd_interwave_isa_probe(struct device *pdev,
>  	}
>  }
>  
> -static int snd_interwave_isa_remove(struct device *devptr, unsigned int dev)
> +static void snd_interwave_isa_remove(struct device *devptr, unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_interwave_driver = {
> diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
> index 24b34ecf5e5b..69647b41300d 100644
> --- a/sound/isa/msnd/msnd_pinnacle.c
> +++ b/sound/isa/msnd/msnd_pinnacle.c
> @@ -1049,10 +1049,9 @@ static int snd_msnd_isa_probe(struct device *pdev, unsigned int idx)
>  #endif
>  }
>  
> -static int snd_msnd_isa_remove(struct device *pdev, unsigned int dev)
> +static void snd_msnd_isa_remove(struct device *pdev, unsigned int dev)
>  {
>  	snd_msnd_unload(dev_get_drvdata(pdev));
> -	return 0;
>  }
>  
>  static struct isa_driver snd_msnd_driver = {
> diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
> index 85a181acd388..7649a8a4128d 100644
> --- a/sound/isa/opl3sa2.c
> +++ b/sound/isa/opl3sa2.c
> @@ -878,11 +878,10 @@ static int snd_opl3sa2_isa_probe(struct device *pdev,
>  	return 0;
>  }
>  
> -static int snd_opl3sa2_isa_remove(struct device *devptr,
> +static void snd_opl3sa2_isa_remove(struct device *devptr,
>  				  unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
> index 44ed1b65f6ce..20933342f5eb 100644
> --- a/sound/isa/opti9xx/miro.c
> +++ b/sound/isa/opti9xx/miro.c
> @@ -1480,11 +1480,10 @@ static int snd_miro_isa_probe(struct device *devptr, unsigned int n)
>  	return 0;
>  }
>  
> -static int snd_miro_isa_remove(struct device *devptr,
> +static void snd_miro_isa_remove(struct device *devptr,
>  			       unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #define DEV_NAME "miro"
> diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
> index 881d3b5711d2..758f5b579138 100644
> --- a/sound/isa/opti9xx/opti92x-ad1848.c
> +++ b/sound/isa/opti9xx/opti92x-ad1848.c
> @@ -1024,11 +1024,10 @@ static int snd_opti9xx_isa_probe(struct device *devptr,
>  	return 0;
>  }
>  
> -static int snd_opti9xx_isa_remove(struct device *devptr,
> -				  unsigned int dev)
> +static void snd_opti9xx_isa_remove(struct device *devptr,
> +				   unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
> index ee379bbf70a4..0e2e0ab3b9e4 100644
> --- a/sound/isa/sb/jazz16.c
> +++ b/sound/isa/sb/jazz16.c
> @@ -339,12 +339,11 @@ static int snd_jazz16_probe(struct device *devptr, unsigned int dev)
>  	return err;
>  }
>  
> -static int snd_jazz16_remove(struct device *devptr, unsigned int dev)
> +static void snd_jazz16_remove(struct device *devptr, unsigned int dev)
>  {
>  	struct snd_card *card = dev_get_drvdata(devptr);
>  
>  	snd_card_free(card);
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
> index 479197c13803..db284b7b88a7 100644
> --- a/sound/isa/sb/sb16.c
> +++ b/sound/isa/sb/sb16.c
> @@ -547,10 +547,9 @@ static int snd_sb16_isa_probe(struct device *pdev, unsigned int dev)
>  	}
>  }
>  
> -static int snd_sb16_isa_remove(struct device *pdev, unsigned int dev)
> +static void snd_sb16_isa_remove(struct device *pdev, unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(pdev));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
> index 438109f167d6..8e3e67b9a341 100644
> --- a/sound/isa/sb/sb8.c
> +++ b/sound/isa/sb/sb8.c
> @@ -192,10 +192,9 @@ static int snd_sb8_probe(struct device *pdev, unsigned int dev)
>  	return err;
>  }
>  
> -static int snd_sb8_remove(struct device *pdev, unsigned int dev)
> +static void snd_sb8_remove(struct device *pdev, unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(pdev));
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM
> diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
> index 3d0bea44f454..def137579717 100644
> --- a/sound/isa/sc6000.c
> +++ b/sound/isa/sc6000.c
> @@ -672,7 +672,7 @@ static int snd_sc6000_probe(struct device *devptr, unsigned int dev)
>  	return err;
>  }
>  
> -static int snd_sc6000_remove(struct device *devptr, unsigned int dev)
> +static void snd_sc6000_remove(struct device *devptr, unsigned int dev)
>  {
>  	struct snd_card *card = dev_get_drvdata(devptr);
>  	char __iomem **vport = card->private_data;
> @@ -684,7 +684,6 @@ static int snd_sc6000_remove(struct device *devptr, unsigned int dev)
>  	release_region(mss_port[dev], 4);
>  
>  	snd_card_free(card);
> -	return 0;
>  }
>  
>  static struct isa_driver snd_sc6000_driver = {
> diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
> index 2e5a5c5279e8..e70ef9aee545 100644
> --- a/sound/isa/sscape.c
> +++ b/sound/isa/sscape.c
> @@ -1183,10 +1183,9 @@ static int snd_sscape_probe(struct device *pdev, unsigned int dev)
>  	return ret;
>  }
>  
> -static int snd_sscape_remove(struct device *devptr, unsigned int dev)
> +static void snd_sscape_remove(struct device *devptr, unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #define DEV_NAME "sscape"
> diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
> index 9e0f6b226775..b750a4fd40de 100644
> --- a/sound/isa/wavefront/wavefront.c
> +++ b/sound/isa/wavefront/wavefront.c
> @@ -565,11 +565,10 @@ static int snd_wavefront_isa_probe(struct device *pdev,
>  	return 0;
>  }
>  
> -static int snd_wavefront_isa_remove(struct device *devptr,
> +static void snd_wavefront_isa_remove(struct device *devptr,
>  				    unsigned int dev)
>  {
>  	snd_card_free(dev_get_drvdata(devptr));
> -	return 0;
>  }
>  
>  #define DEV_NAME "wavefront"
> 

