Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13992CDFCB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgLCUjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:39:06 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:22507 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCUjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:39:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607027922; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=NqqsioQp0zqO93CJ60s2PFPzD2BsY6xnwm43kA5jPVk=;
 b=eymEcLxgYR4IMScTB6NbrEL3JY/Z/taRfsIfKk5U3Ft9lT07SEOX2yVkLKN+cJz7AzeLae0O
 Ep0QEKsaUhSNcf56V9I7jdzL645mI3uSxJfLah5Bk5rgTS7PbW2IklOVUa7Tjuyz/AdcB79j
 QOaHK1mtBKsv5KHuG9LgySWt+Xk=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fc94cb396285165cddf8819 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 20:38:11
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E3BAEC433ED; Thu,  3 Dec 2020 20:38:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76787C43461;
        Thu,  3 Dec 2020 20:38:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 13:38:09 -0700
From:   jhugo@codeaurora.org
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org, hemantk=codeaurora.org@codeaurora.org
Subject: Re: [PATCH v14 3/4] docs: Add documentation for userspace client
 interface
In-Reply-To: <1606877991-26368-4-git-send-email-hemantk@codeaurora.org>
References: <1606877991-26368-1-git-send-email-hemantk@codeaurora.org>
 <1606877991-26368-4-git-send-email-hemantk@codeaurora.org>
Message-ID: <86747d3a0e8555ee5369aaa3cb2ff947@codeaurora.org>
X-Sender: jhugo@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-01 19:59, Hemant Kumar wrote:
> MHI userspace client driver is creating device file node
> for user application to perform file operations. File
> operations are handled by MHI core driver. Currently
> QMI MHI channel is supported by this driver.
> 
> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>

Two minor nits below.  With those -
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>

> ---
>  Documentation/mhi/index.rst |  1 +
>  Documentation/mhi/uci.rst   | 94 
> +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 95 insertions(+)
>  create mode 100644 Documentation/mhi/uci.rst
> 
> diff --git a/Documentation/mhi/index.rst b/Documentation/mhi/index.rst
> index 1d8dec3..c75a371 100644
> --- a/Documentation/mhi/index.rst
> +++ b/Documentation/mhi/index.rst
> @@ -9,6 +9,7 @@ MHI
> 
>     mhi
>     topology
> +   uci
> 
>  .. only::  subproject and html
> 
> diff --git a/Documentation/mhi/uci.rst b/Documentation/mhi/uci.rst
> new file mode 100644
> index 0000000..9603f92
> --- /dev/null
> +++ b/Documentation/mhi/uci.rst
> @@ -0,0 +1,94 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=================================
> +Userspace Client Interface (UCI)
> +=================================
> +
> +UCI driver enables userspace clients to communicate to external MHI 
> devices
> +like modem and WLAN. UCI driver probe creates standard character 
> device file
> +nodes for userspace clients to perform open, read, write, poll and 
> release file
> +operations. UCI device object represents UCI device file node which 
> gets
> +instantiated as part of MHI UCI driver probe. UCI channel object 
> represents
> +MHI uplink or downlink channel.
> +
> +Operations
> +==========
> +
> +open
> +----
> +
> +Instantiates UCI channel object and starts MHI channels to move it to 
> running
> +state. Inbound buffers are queued to downlink channel transfer ring. 
> Every
> +subsequent open() increments UCI device reference count as well as UCI 
> channel
> +reference count.
> +
> +read
> +----
> +
> +When data transfer is completed on downlink channel, transfer ring 
> element
> +buffer is copied to pending list. Reader is unblocked and data is 
> copied to
> +userspace buffer. Transfer ring element buffer is queued back to 
> downlink
> +channel transfer ring.
> +
> +write
> +-----
> +
> +Write buffer is queued to uplink channel transfer ring if ring is not
> full. Upon
> +uplink transfer completion buffer is freed.
> +
> +poll
> +----
> +
> +Returns EPOLLIN | EPOLLRDNORM mask if pending list has buffers to be 
> read by
> +userspace. Returns EPOLLOUT | EPOLLWRNORM mask if MHI uplink channel 
> transfer
> +ring is not empty. Returns EPOLLERR when UCI driver is removed.

ring is not empty.  When the uplink channel transfer ring is non-empty, 
more
data may be sent to the device. Returns EPOLLERR when UCI driver is 
removed.

> +
> +release
> +-------
> +
> +Decrements UCI device reference count and UCI channel reference count 
> upon last
> +release(). UCI channel clean up is performed. MHI channel moves to 
> disable
> +state and inbound buffers are freed.

Decrements UCI device reference count and UCI channel reference count. 
Upon last
release() UCI channel clean up is performed. MHI channel moves to 
disable
state and inbound buffers are freed.

> +
> +Usage
> +=====
> +
> +Device file node is created with format:-
> +
> +/dev/<mhi_device_name>
> +
> +mhi_device_name includes mhi controller name and the name of the MHI 
> channel
> +being used by MHI client in userspace to send or receive data using 
> MHI
> +protocol.
> +
> +There is a separate character device file node created for each 
> channel
> +specified in MHI device id table. MHI channels are statically defined 
> by MHI
> +specification. The list of supported channels is in the channel list 
> variable
> +of mhi_device_id table in UCI driver.
> +
> +Qualcomm MSM Interface(QMI) Channel
> +-----------------------------------
> +
> +Qualcomm MSM Interface(QMI) is a modem control messaging protocol used 
> to
> +communicate between software components in the modem and other 
> peripheral
> +subsystems. QMI communication is of request/response type or an 
> unsolicited
> +event type. libqmi is userspace MHI client which communicates to a QMI 
> service
> +using UCI device. It sends a QMI request to a QMI service using MHI 
> channel 14
> +or 16. QMI response is received using MHI channel 15 or 17 
> respectively. libqmi
> +is a glib-based library for talking to WWAN modems and devices which 
> speaks QMI
> +protocol. For more information about libqmi please refer
> +https://www.freedesktop.org/wiki/Software/libqmi/
> +
> +Usage Example
> +~~~~~~~~~~~~~
> +
> +QMI command to retrieve device mode
> +$ sudo qmicli -d /dev/mhi0_QMI --dms-get-model
> +[/dev/mhi0_QMI] Device model retrieved:
> +    Model: 'FN980m'
> +
> +Other Use Cases
> +---------------
> +
> +Getting MHI device specific diagnostics information to userspace MHI 
> diagnostic
> +client using DIAG channel 4 (Host to device) and 5 (Device to Host).
