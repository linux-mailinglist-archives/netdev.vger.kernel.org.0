Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561352C9481
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgLABRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:17:09 -0500
Received: from z5.mailgun.us ([104.130.96.5]:28816 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgLABRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:17:09 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606785409; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=b9xG0nohUwSnQ3pYpgsP+NV1uIFeQ16NwbRzsCQSzQg=; b=GdAEWtr+PZf0LsJLWNC4fR7k5FoBkmQs0ItDt2c9aLUK5qZ13eXctA6qRvvQI+Ipt7jVuj2Z
 z+U5IMQax8ZgonR2cLfgL1DDoLvR65Wp/K5OxP9U/xIYuHmdvGE2QOi4/vUqz7GowSAkq5Ms
 FdSQ0oVmH20QcUol1XEoRmXd1fw=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fc5997fe8c9bf49ad6bbcd2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 01:16:47
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 61604C433ED; Tue,  1 Dec 2020 01:16:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C140EC433C6;
        Tue,  1 Dec 2020 01:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C140EC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <c47dcd57-7576-e03e-f70b-0c4d25f724b5@codeaurora.org>
Date:   Mon, 30 Nov 2020 17:16:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 11/30/20 10:22 AM, Loic Poulain wrote:
> On Sat, 28 Nov 2020 at 04:26, Hemant Kumar <hemantk@codeaurora.org> wrote:
>>
>> This MHI client driver allows userspace clients to transfer
>> raw data between MHI device and host using standard file operations.
>> Driver instantiates UCI device object which is associated to device
>> file node. UCI device object instantiates UCI channel object when device
>> file node is opened. UCI channel object is used to manage MHI channels
>> by calling MHI core APIs for read and write operations. MHI channels
>> are started as part of device open(). MHI channels remain in start
>> state until last release() is called on UCI device file node. Device
>> file node is created with format
> 
> [...]
> 
>> +struct uci_chan {
>> +       struct uci_dev *udev;
>> +       wait_queue_head_t ul_wq;
>> +
>> +       /* ul channel lock to synchronize multiple writes */
>> +       struct mutex write_lock;
>> +
>> +       wait_queue_head_t dl_wq;
>> +
>> +       /* dl channel lock to synchronize multiple reads */
>> +       struct mutex read_lock;
>> +
>> +       /*
>> +        * protects pending list in bh context, channel release, read and
>> +        * poll
>> +        */
>> +       spinlock_t dl_pending_lock;
>> +
>> +       struct list_head dl_pending;
>> +       struct uci_buf *cur_buf;
>> +       size_t dl_size;
>> +       struct kref ref_count;
>> +};
> 
> [...]
> 
>> + * struct uci_dev - MHI UCI device
>> + * @minor: UCI device node minor number
>> + * @mhi_dev: associated mhi device object
>> + * @uchan: UCI uplink and downlink channel object
>> + * @mtu: max TRE buffer length
>> + * @enabled: Flag to track the state of the UCI device
>> + * @lock: mutex lock to manage uchan object
>> + * @ref_count: uci_dev reference count
>> + */
>> +struct uci_dev {
>> +       unsigned int minor;
>> +       struct mhi_device *mhi_dev;
>> +       struct uci_chan *uchan;
> 
> Why a pointer to uci_chan and not just plainly integrating the
> structure here, AFAIU uci_chan describes the channels and is just a
> subpart of uci_dev. That would reduce the number of dynamic
> allocations you manage and the extra kref. do you even need a separate
> structure for this?

This goes back to one of my patch versions i tried to address concern 
from Greg. Since we need to ref count the channel as well as the uci 
device i decoupled the two objects and used two reference counts for two 
different objects.

Copying from V7 patch history

V7:
- Decoupled uci device and uci channel objects. uci device is
   associated with device file node. uci channel is associated
   with MHI channels. uci device refers to uci channel to perform
   MHI channel operations for device file operations like read()
   and write(). uci device increments its reference count for
   every open(). uci device calls mhi_uci_dev_start_chan() to start
   the MHI channel. uci channel object is tracking number of times
   MHI channel is referred. This allows to keep the MHI channel in
   start state until last release() is called. After that uci channel
   reference count goes to 0 and uci channel clean up is performed
   which stops the MHI channel. After the last call to release() if
   driver is removed uci reference count becomes 0 and uci object is
   cleaned up.

> 
> [...]
> 
>> +static int mhi_uci_dev_start_chan(struct uci_dev *udev)
>> +{
>> +       int ret = 0;
>> +       struct uci_chan *uchan;
>> +
>> +       mutex_lock(&udev->lock);
>> +       if (!udev->uchan || !kref_get_unless_zero(&udev->uchan->ref_count)) {
> 
> This test is suspicious,  kref_get_unless_zero should be enough to test, right?
kref_get_unless_zero is de-referencing uchan->ref_count for the first 
open uchan is set to NULL, for that NULL check is added for uchan.
> 
> if (kref_get_unless_zero(&udev->ref))
>      goto skip_init;
> 
>> +               uchan = kzalloc(sizeof(*uchan), GFP_KERNEL);
>> +               if (!uchan) {
>> +                       ret = -ENOMEM;
>> +                       goto error_chan_start;
>> +               }
>> +
>> +               udev->uchan = uchan;
>> +               uchan->udev = udev;
>> +               init_waitqueue_head(&uchan->ul_wq);
>> +               init_waitqueue_head(&uchan->dl_wq);
>> +               mutex_init(&uchan->write_lock);
>> +               mutex_init(&uchan->read_lock);
>> +               spin_lock_init(&uchan->dl_pending_lock);
>> +               INIT_LIST_HEAD(&uchan->dl_pending);
>> +
>> +               ret = mhi_prepare_for_transfer(udev->mhi_dev);
>> +               if (ret) {
>> +                       dev_err(&udev->mhi_dev->dev, "Error starting transfer channels\n");
>> +                       goto error_chan_cleanup;
>> +               }
>> +
>> +               ret = mhi_queue_inbound(udev);
>> +               if (ret)
>> +                       goto error_chan_cleanup;
>> +
>> +               kref_init(&uchan->ref_count);
>> +       }
>> +
>> +       mutex_unlock(&udev->lock);
>> +
>> +       return 0;
>> +
>> +error_chan_cleanup:
>> +       mhi_uci_dev_chan_release(&uchan->ref_count);
>> +error_chan_start:
>> +       mutex_unlock(&udev->lock);
>> +       return ret;
>> +}
> 
> Regards,
> Loic
> 

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
