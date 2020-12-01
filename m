Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196802CAF4F
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbgLAWAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:01 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:40029 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390570AbgLAWAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 17:00:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606859974; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=M/8NwuuqY6NxdUYerQYtC/Kfpd17GBu4f3BYrYGb00I=; b=rUmpo6cUpMjfqxZCn7xN47wliggvZBo70TYm3VslhgWqrlVLNpSsVwbKPC2mPuOO7F9DnPVJ
 vT2P6dNtG+kG3m2wdeyH+du5MhSiDqGSw7HMu/T/LX+DkDLHF/sjvf0NNsRyzxaw/8Muqv8b
 /5gqR4JH/DLDn60Ksp6bPPFT3rs=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fc6bca9e8c9bf49ad7b0b20 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 21:59:05
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6F71FC43460; Tue,  1 Dec 2020 21:59:05 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 83801C433ED;
        Tue,  1 Dec 2020 21:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 83801C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Jeffrey Hugo <jhugo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org>
 <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com>
 <c47dcd57-7576-e03e-f70b-0c4d25f724b5@codeaurora.org>
 <CAMZdPi8mUV5cFs-76K3kg=hN8ht2SKjJwzbJH-+VH4Y8QabcHQ@mail.gmail.com>
 <1247e32e-ed67-de6b-81ec-3bde9ad93250@codeaurora.org>
 <CAMZdPi-tjmXWAFzZJAg_6U5h2ZJv478E88T-Lmk=YA-B6=MzRA@mail.gmail.com>
 <1a9f7ed5-7060-9146-47ff-087b9096ba3a@codeaurora.org>
 <CAMZdPi_=k95C0TTJDvRfYcFtqm6kSLfWHZ6CKpksAD=1P5vtfA@mail.gmail.com>
 <73ca4025-47a1-ff5f-2d85-e8f524f819b3@codeaurora.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <57bd8357-3a5d-30e0-293a-eb71d947d3a5@codeaurora.org>
Date:   Tue, 1 Dec 2020 13:59:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <73ca4025-47a1-ff5f-2d85-e8f524f819b3@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 12/1/20 10:04 AM, Jeffrey Hugo wrote:
> On 12/1/2020 11:05 AM, Loic Poulain wrote:
>> On Tue, 1 Dec 2020 at 18:51, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
>>>
>>> On 12/1/2020 10:52 AM, Loic Poulain wrote:
>>>> On Tue, 1 Dec 2020 at 18:37, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
>>>>>
>>>>> On 12/1/2020 10:36 AM, Loic Poulain wrote:
>>>>>> On Tue, 1 Dec 2020 at 02:16, Hemant Kumar <hemantk@codeaurora.org> 
>>>>>> wrote:
>>>>>>>
>>>>>>> Hi Loic,
>>>>>>>
>>>>>>> On 11/30/20 10:22 AM, Loic Poulain wrote:
>>>>>>>> On Sat, 28 Nov 2020 at 04:26, Hemant Kumar 
>>>>>>>> <hemantk@codeaurora.org> wrote:
>>>>>>>>>
>>>>>>>>> This MHI client driver allows userspace clients to transfer
>>>>>>>>> raw data between MHI device and host using standard file 
>>>>>>>>> operations.
>>>>>>>>> Driver instantiates UCI device object which is associated to 
>>>>>>>>> device
>>>>>>>>> file node. UCI device object instantiates UCI channel object 
>>>>>>>>> when device
>>>>>>>>> file node is opened. UCI channel object is used to manage MHI 
>>>>>>>>> channels
>>>>>>>>> by calling MHI core APIs for read and write operations. MHI 
>>>>>>>>> channels
>>>>>>>>> are started as part of device open(). MHI channels remain in start
>>>>>>>>> state until last release() is called on UCI device file node. 
>>>>>>>>> Device
>>>>>>>>> file node is created with format
>>>>>>>>
>>>>>>>> [...]
>>>>>>>>
>>>>>>>>> +struct uci_chan {
>>>>>>>>> +       struct uci_dev *udev;
>>>>>>>>> +       wait_queue_head_t ul_wq;
>>>>>>>>> +
>>>>>>>>> +       /* ul channel lock to synchronize multiple writes */
>>>>>>>>> +       struct mutex write_lock;
>>>>>>>>> +
>>>>>>>>> +       wait_queue_head_t dl_wq;
>>>>>>>>> +
>>>>>>>>> +       /* dl channel lock to synchronize multiple reads */
>>>>>>>>> +       struct mutex read_lock;
>>>>>>>>> +
>>>>>>>>> +       /*
>>>>>>>>> +        * protects pending list in bh context, channel 
>>>>>>>>> release, read and
>>>>>>>>> +        * poll
>>>>>>>>> +        */
>>>>>>>>> +       spinlock_t dl_pending_lock;
>>>>>>>>> +
>>>>>>>>> +       struct list_head dl_pending;
>>>>>>>>> +       struct uci_buf *cur_buf;
>>>>>>>>> +       size_t dl_size;
>>>>>>>>> +       struct kref ref_count;
>>>>>>>>> +};
>>>>>>>>
>>>>>>>> [...]
>>>>>>>>
>>>>>>>>> + * struct uci_dev - MHI UCI device
>>>>>>>>> + * @minor: UCI device node minor number
>>>>>>>>> + * @mhi_dev: associated mhi device object
>>>>>>>>> + * @uchan: UCI uplink and downlink channel object
>>>>>>>>> + * @mtu: max TRE buffer length
>>>>>>>>> + * @enabled: Flag to track the state of the UCI device
>>>>>>>>> + * @lock: mutex lock to manage uchan object
>>>>>>>>> + * @ref_count: uci_dev reference count
>>>>>>>>> + */
>>>>>>>>> +struct uci_dev {
>>>>>>>>> +       unsigned int minor;
>>>>>>>>> +       struct mhi_device *mhi_dev;
>>>>>>>>> +       struct uci_chan *uchan;
>>>>>>>>
>>>>>>>> Why a pointer to uci_chan and not just plainly integrating the
>>>>>>>> structure here, AFAIU uci_chan describes the channels and is just a
>>>>>>>> subpart of uci_dev. That would reduce the number of dynamic
>>>>>>>> allocations you manage and the extra kref. do you even need a 
>>>>>>>> separate
>>>>>>>> structure for this?
>>>>>>>
>>>>>>> This goes back to one of my patch versions i tried to address 
>>>>>>> concern
>>>>>>> from Greg. Since we need to ref count the channel as well as the uci
>>>>>>> device i decoupled the two objects and used two reference counts 
>>>>>>> for two
>>>>>>> different objects.
>>>>>>
>>>>>> What Greg complained about is the two kref in the same structure and
>>>>>> that you were using kref as an open() counter. But splitting your
>>>>>> struct in two in order to keep the two kref does not make the much
>>>>>> code better (and simpler). I'm still a bit puzzled about the driver
>>>>>> complexity, it's supposed to be just a passthrough interface to MHI
>>>>>> after all.
>>>>>>
>>>>>> I would suggest several changes, that IMHO would simplify reviewing:
>>>>>> - Use only one structure representing the 'uci' context (uci_dev)
>>>>>> - Keep the read path simple (mhi_uci_read), do no use an intermediate
>>>>>> cur_buf pointer, only dequeue the buffer when it is fully consumed.
>>>>>> - As I commented before, take care of the dl_pending list access
>>>>>> concurrency, even in wait_event.
>>>>>> - You don't need to count the number of open() calls, AFAIK,
>>>>>> mhi_prepare_for_transfer() simply fails if channels are already
>>>>>> started...
>>>>>
>>>>> Unless I missed something, you seem to have ignored the root issue 
>>>>> that
>>>>> Hemant needs to solve, which is when to call
>>>>> mhi_unprepare_for_transfer().  You can't just call that when 
>>>>> close() is
>>>>> called because there might be multiple users, and each one is going to
>>>>> trigger a close(), so you need to know how many close() instances to
>>>>> expect, and only call mhi_unprepare_for_transfer() for the last one.
>>>>
>>>> That one part of his problem, yes, but if you unconditionally call
>>>> mhi_prepare_for_transfer in open(), it should fail for subsequent
>>>> users, and so only one user will successfully open the device.
>>>
>>> I'm pretty sure that falls under "trying to prevent users from opening a
>>> device" which Greg gave a pretty strong NACK to.  So, that's not a 
>>> solution.
>>
>> That would deserve clarification since other drivers like
>> virtio_console clearly prevent that (guest_connected).
> 
> Quoting Greg from the source - https://lkml.org/lkml/2020/9/17/873
> 
> "
> I told you before, do not try to keep a device node from being opened
> multiple times, as it will always fail (think about passing file handles
> around between programs...)
> 
> If userspace wants to do this, it will do it.  If your driver can't
> handle that, that's fine, userspace will learn not to do that.  But the
> kernel can not prevent this from happening.
> "
> 
>>
>>>
>>> So, the complete problem is -
>>>
>>> N users need to be able to use the device (and by proxy, the channel)
>>> concurrently, but prepare needs to be called on the first user coming
>>> into the picture, and unprepare needs to be called on the last user
>>> exiting the picture.
>>>
>>> Hemant has supported this usecase in every rev of this series I've
>>> looked at, but apparently every solution he has proposed to handle this
>>> has caused confusion.
>>
>> Understood, but that can be done with a simple counter in that case.
If you look at the old original patch set, it was using simple counter 
and Greg suggested to move away from that and use kref object, and then all
incremental changes done using single kref object udev to two separate 
objects udev and uchan (introduced in v7).

Based on every reviewer's comment i thought driver looked cleaner and 
moved away from complicated implementations when it was introduced 
initially. If every one still agrees to that we can move forward with 
its current form which includes valuable suggestions from all the 
reviewers.

Thanks for testing my Change on your setup Loic. Mani wants me to update 
the Documentation patch by modifying the QMI usage example. I am going 
to upload next revision by updating the documentation.

LOOPBACK test application and its inclusion to mhi device id table would 
be a separate patch series. Will share the LOOPBACK test application 
public git hub link in Documentation.

Thanks Jeff for providing the background of the discussions from the past.

Thanks,
Hemant
>>
>> Regards,
>> Loic
>>
> 
> 

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
