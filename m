Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473B68185F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 13:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfHELrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 07:47:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45944 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbfHELrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 07:47:16 -0400
Received: by mail-lf1-f66.google.com with SMTP id u10so18935029lfm.12;
        Mon, 05 Aug 2019 04:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XqfbHS+kotk8JoRbfLuGqMSPe/L9zMN6nAynv8vWNNE=;
        b=O+OAZdfs0epR4mar8rurpUaubeHEoz9RUhXnXCuUIg6fivHNXgeGlhOIz3MhMXy3jt
         MEu7lumoLYRKU4Bf4XZ2+iLAIXDFudMGWug7EKm3kDy9lk+nKf/A016vXX58tflFzf+x
         9FXuMkisWjyiAmR4iBYZsg23rY9w4e86gH21TdkZFyGIPD8fsYUdvL2cRolPFGGBlMg7
         Bi7POE68YNYEYdBUd5IchMIhnZ4F0HV9bVw3/r5bENRwLQ/9xHXsx0AxwFIOs2AF6wm4
         fd4HPt0NxWIio9LTlgp6YzbP9p5I4oPeSAfe9foFd4cYabD1aDlwgIr2DjCwTRFfaeVM
         6rwA==
X-Gm-Message-State: APjAAAXh+FjAQdSS8+xVCiKwg9SCmivlvwadI1R58wdgHLuBflabJfMF
        IgzaHSChCyVskxvc0lkoMNtclfqY2GM=
X-Google-Smtp-Source: APXvYqwCQQpWwF/H86pq5gU6luyGEhhHPzYgbnkV99GOKcMkH1wANYUuU+ymSzgAiP1aj/rOjAxasw==
X-Received: by 2002:a19:a419:: with SMTP id q25mr5603054lfc.136.1565005633919;
        Mon, 05 Aug 2019 04:47:13 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id p21sm14866073lfc.41.2019.08.05.04.47.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 04:47:13 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hubSJ-0006DC-U0; Mon, 05 Aug 2019 13:47:11 +0200
Date:   Mon, 5 Aug 2019 13:47:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "Angus Ainslie (Purism)" <angus@akkea.ca>
Cc:     kernel@puri.sm, =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bob Ham <bob.ham@puri.sm>
Subject: Re: [PATCH 1/2] usb: serial: option: Add the BroadMobi BM818 card
Message-ID: <20190805114711.GF3574@localhost>
References: <20190724145227.27169-1-angus@akkea.ca>
 <20190724145227.27169-2-angus@akkea.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724145227.27169-2-angus@akkea.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 07:52:26AM -0700, Angus Ainslie (Purism) wrote:
> From: Bob Ham <bob.ham@puri.sm>
> 
> Add a VID:PID for the BroadModi BM818 M.2 card

Would you mind posting the output of usb-devices (or lsusb -v) for this
device?

> Signed-off-by: Bob Ham <bob.ham@puri.sm>
> Signed-off-by: Angus Ainslie (Purism) <angus@akkea.ca>
> ---
>  drivers/usb/serial/option.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index c1582fbd1150..674a68ee9564 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1975,6 +1975,8 @@ static const struct usb_device_id option_ids[] = {
>  	  .driver_info = RSVD(4) | RSVD(5) },
>  	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
>  	  .driver_info = RSVD(6) },
> +	{ USB_DEVICE(0x2020, 0x2060),						/* BroadMobi  */

Looks like you forgot to include the model in the comment here.

And please move this one after the other 0x2020 (PID 0x2031) entry.

Should you also be using USB_DEVICE_INTERFACE_CLASS() (e.g. to avoid
matching a mass-storage interface)?

> +	  .driver_info = RSVD(4) },
>  	{ } /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, option_ids);

Johan
