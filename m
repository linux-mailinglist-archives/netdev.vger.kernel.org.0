Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714AF51FA74
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiEIKvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiEIKuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE52E2CC10B;
        Mon,  9 May 2022 03:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A22660FD6;
        Mon,  9 May 2022 10:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CCB2C385B1;
        Mon,  9 May 2022 10:46:21 +0000 (UTC)
Message-ID: <73a603a2-5e5e-1b45-8e19-ab0795027336@xs4all.nl>
Date:   Mon, 9 May 2022 12:46:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 4/8] drivers: use new capable_or functionality
Content-Language: en-US
To:     =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>,
        selinux@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Ondrej Zary <linux@zary.sk>,
        David Yang <davidcomponentone@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Colin Ian King <colin.king@intel.com>,
        Yang Guang <yang.guang5@zte.com.cn>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Du Cheng <ducheng2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-security-module@vger.kernel.org
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
 <20220502160030.131168-3-cgzones@googlemail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
In-Reply-To: <20220502160030.131168-3-cgzones@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/22 18:00, Christian Göttsche wrote:
> Use the new added capable_or function in appropriate cases, where a task
> is required to have any of two capabilities.
> 
> Reorder CAP_SYS_ADMIN last.
> 
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> ---
>  drivers/media/common/saa7146/saa7146_video.c     | 2 +-
>  drivers/media/pci/bt8xx/bttv-driver.c            | 3 +--
>  drivers/media/pci/saa7134/saa7134-video.c        | 3 +--
>  drivers/media/platform/nxp/fsl-viu.c             | 2 +-
>  drivers/media/test-drivers/vivid/vivid-vid-cap.c | 2 +-

For the media drivers:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

>  drivers/net/caif/caif_serial.c                   | 2 +-
>  drivers/s390/block/dasd_eckd.c                   | 2 +-
>  7 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
> index 66215d9106a4..5eabc2e77cc2 100644
> --- a/drivers/media/common/saa7146/saa7146_video.c
> +++ b/drivers/media/common/saa7146/saa7146_video.c
> @@ -470,7 +470,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuf
>  
>  	DEB_EE("VIDIOC_S_FBUF\n");
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 5ca3d0cc653a..4143f380d44d 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2569,8 +2569,7 @@ static int bttv_s_fbuf(struct file *file, void *f,
>  	const struct bttv_format *fmt;
>  	int retval;
>  
> -	if (!capable(CAP_SYS_ADMIN) &&
> -		!capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
> index 48543ad3d595..684208ebfdbd 100644
> --- a/drivers/media/pci/saa7134/saa7134-video.c
> +++ b/drivers/media/pci/saa7134/saa7134-video.c
> @@ -1798,8 +1798,7 @@ static int saa7134_s_fbuf(struct file *file, void *f,
>  	struct saa7134_dev *dev = video_drvdata(file);
>  	struct saa7134_format *fmt;
>  
> -	if (!capable(CAP_SYS_ADMIN) &&
> -	   !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/platform/nxp/fsl-viu.c b/drivers/media/platform/nxp/fsl-viu.c
> index afc96f6db2a1..c5ed4c4a1587 100644
> --- a/drivers/media/platform/nxp/fsl-viu.c
> +++ b/drivers/media/platform/nxp/fsl-viu.c
> @@ -803,7 +803,7 @@ static int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_frameb
>  	const struct v4l2_framebuffer *fb = arg;
>  	struct viu_fmt *fmt;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* check args */
> diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> index b9caa4b26209..a0cfcf6c22c4 100644
> --- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> +++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
> @@ -1253,7 +1253,7 @@ int vivid_vid_cap_s_fbuf(struct file *file, void *fh,
>  	if (dev->multiplanar)
>  		return -ENOTTY;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	if (dev->overlay_cap_owner)
> diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
> index 688075859ae4..f17b618d8858 100644
> --- a/drivers/net/caif/caif_serial.c
> +++ b/drivers/net/caif/caif_serial.c
> @@ -326,7 +326,7 @@ static int ldisc_open(struct tty_struct *tty)
>  	/* No write no play */
>  	if (tty->ops->write == NULL)
>  		return -EOPNOTSUPP;
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_TTY_CONFIG))
> +	if (!capable_or(CAP_SYS_TTY_CONFIG, CAP_SYS_ADMIN))
>  		return -EPERM;
>  
>  	/* release devices to avoid name collision */
> diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
> index 8410a25a65c1..9b5d22dd3e7b 100644
> --- a/drivers/s390/block/dasd_eckd.c
> +++ b/drivers/s390/block/dasd_eckd.c
> @@ -5319,7 +5319,7 @@ static int dasd_symm_io(struct dasd_device *device, void __user *argp)
>  	char psf0, psf1;
>  	int rc;
>  
> -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RAWIO))
> +	if (!capable_or(CAP_SYS_RAWIO, CAP_SYS_ADMIN))
>  		return -EACCES;
>  	psf0 = psf1 = 0;
>  
