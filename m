Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB64D3C9835
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 07:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239530AbhGOFVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 01:21:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238248AbhGOFVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 01:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626326334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D8iu1FpkB+Q5MbUloar5V7lmwIaalXyd5WoD2kAIHNw=;
        b=AAvvEwInxhRLOhwBQ12NEIrx8luON60d3WGE46Z4721PtPL35893AgP4FXkF43yq0DvQ5S
        TN/H75YEUccienI1S/gcRIOQhvy958OC7ItjVlEUXmunyYqeVGF43CeGZmNCcm9rWRXifu
        HsjwMYAkeqGfVQZ/4sx/134uRazbKJE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-lfao45k-PsuEJbDH78_PpA-1; Thu, 15 Jul 2021 01:18:53 -0400
X-MC-Unique: lfao45k-PsuEJbDH78_PpA-1
Received: by mail-pf1-f200.google.com with SMTP id t18-20020a056a001392b02903039eb2e663so3408340pfg.5
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 22:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=D8iu1FpkB+Q5MbUloar5V7lmwIaalXyd5WoD2kAIHNw=;
        b=fq5z2tRi6Ahdp8HfwYMB32J2VIa2VsRd37xhtFWcSmOa/YKoDYvZ949RiXr11I8jlE
         tZUIa23dOfBjJbBg16XaYlXmbSONrMEUBij3r18PhC8VDujpmenRnSFAIa06s6A0NMXx
         zBakrP5OgVnWwxUmOHRs2UPyJgPPTUXhI/dWkIWJ3Gtdvx/tFM9XknKcP/dwcJQADgDn
         sm30/9686YBoxmfiGQtC1c2c6kyVwDj3ad62vrhBr7sycNA4yAnvGEt+9yO0VqJE6Ih4
         cZGMnrnHRnfiJsUo14a2cmouc53MgF8zUxBDU4zrW9+tZLhFqY4lKMpzojSHA5mD4HrO
         v5Kg==
X-Gm-Message-State: AOAM533TQquSQL8BigqagFQr5KkFUDfCorMGLIQG241vYuKhcrkgWgVx
        nBflPO8rXuO7ys4c8DFok84uwD1+3auK9V2AqPh+8wvmSBCkfT2jPhvXELMh8YIjWNQ8Hs/yJYI
        ey+7d9DufAgAN/RH5
X-Received: by 2002:a63:d612:: with SMTP id q18mr2461966pgg.77.1626326332530;
        Wed, 14 Jul 2021 22:18:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGXXNZvNMbfJ1ayJ84wTUoIyWrupsA4bSY61FZYpuY+xYuvdeZDlXik5etewzOSKCiU/lCjg==
X-Received: by 2002:a63:d612:: with SMTP id q18mr2461930pgg.77.1626326332190;
        Wed, 14 Jul 2021 22:18:52 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t5sm5602845pgb.58.2021.07.14.22.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 22:18:51 -0700 (PDT)
Subject: Re: [PATCH v9 17/17] Documentation: Add documentation for VDUSE
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-18-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e8f25a35-9d45-69f9-795d-bdbbb90337a3@redhat.com>
Date:   Thu, 15 Jul 2021 13:18:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713084656.232-18-xieyongji@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/13 下午4:46, Xie Yongji 写道:
> VDUSE (vDPA Device in Userspace) is a framework to support
> implementing software-emulated vDPA devices in userspace. This
> document is intended to clarify the VDUSE design and usage.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/userspace-api/index.rst |   1 +
>   Documentation/userspace-api/vduse.rst | 248 ++++++++++++++++++++++++++++++++++
>   2 files changed, 249 insertions(+)
>   create mode 100644 Documentation/userspace-api/vduse.rst
>
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
> index 0b5eefed027e..c432be070f67 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -27,6 +27,7 @@ place where this information is gathered.
>      iommu
>      media/index
>      sysfs-platform_profile
> +   vduse
>   
>   .. only::  subproject and html
>   
> diff --git a/Documentation/userspace-api/vduse.rst b/Documentation/userspace-api/vduse.rst
> new file mode 100644
> index 000000000000..2c0d56d4b2da
> --- /dev/null
> +++ b/Documentation/userspace-api/vduse.rst
> @@ -0,0 +1,248 @@
> +==================================
> +VDUSE - "vDPA Device in Userspace"
> +==================================
> +
> +vDPA (virtio data path acceleration) device is a device that uses a
> +datapath which complies with the virtio specifications with vendor
> +specific control path. vDPA devices can be both physically located on
> +the hardware or emulated by software. VDUSE is a framework that makes it
> +possible to implement software-emulated vDPA devices in userspace. And
> +to make the device emulation more secure, the emulated vDPA device's
> +control path is handled in the kernel and only the data path is
> +implemented in the userspace.
> +
> +Note that only virtio block device is supported by VDUSE framework now,
> +which can reduce security risks when the userspace process that implements
> +the data path is run by an unprivileged user. The support for other device
> +types can be added after the security issue of corresponding device driver
> +is clarified or fixed in the future.
> +
> +Start/Stop VDUSE devices
> +------------------------
> +
> +VDUSE devices are started as follows:


Not native speaker but "created" is probably better.


> +
> +1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> +   /dev/vduse/control.
> +
> +2. Setup each virtqueue with ioctl(VDUSE_VQ_SETUP) on /dev/vduse/$NAME.
> +
> +3. Begin processing VDUSE messages from /dev/vduse/$NAME. The first
> +   messages will arrive while attaching the VDUSE instance to vDPA bus.
> +
> +4. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> +   instance to vDPA bus.


I think 4 should be done before 3?


> +
> +VDUSE devices are stopped as follows:


"removed" or "destroyed" is better than "stopped" here.


> +
> +1. Send the VDPA_CMD_DEV_DEL netlink message to detach the VDUSE
> +   instance from vDPA bus.
> +
> +2. Close the file descriptor referring to /dev/vduse/$NAME.
> +
> +3. Destroy the VDUSE instance with ioctl(VDUSE_DESTROY_DEV) on
> +   /dev/vduse/control.
> +
> +The netlink messages can be sent via vdpa tool in iproute2 or use the
> +below sample codes:
> +
> +.. code-block:: c
> +
> +	static int netlink_add_vduse(const char *name, enum vdpa_command cmd)
> +	{
> +		struct nl_sock *nlsock;
> +		struct nl_msg *msg;
> +		int famid;
> +
> +		nlsock = nl_socket_alloc();
> +		if (!nlsock)
> +			return -ENOMEM;
> +
> +		if (genl_connect(nlsock))
> +			goto free_sock;
> +
> +		famid = genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> +		if (famid < 0)
> +			goto close_sock;
> +
> +		msg = nlmsg_alloc();
> +		if (!msg)
> +			goto close_sock;
> +
> +		if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, famid, 0, 0, cmd, 0))
> +			goto nla_put_failure;
> +
> +		NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> +		if (cmd == VDPA_CMD_DEV_NEW)
> +			NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vduse");
> +
> +		if (nl_send_sync(nlsock, msg))
> +			goto close_sock;
> +
> +		nl_close(nlsock);
> +		nl_socket_free(nlsock);
> +
> +		return 0;
> +	nla_put_failure:
> +		nlmsg_free(msg);
> +	close_sock:
> +		nl_close(nlsock);
> +	free_sock:
> +		nl_socket_free(nlsock);
> +		return -1;
> +	}
> +
> +How VDUSE works
> +---------------
> +
> +As mentioned above, a VDUSE device is created by ioctl(VDUSE_CREATE_DEV) on
> +/dev/vduse/control. With this ioctl, userspace can specify some basic configuration
> +such as device name (uniquely identify a VDUSE device), virtio features, virtio
> +configuration space, bounce buffer size


This bounce buffer size looks questionable. We'd better not expose any 
implementation details to userspace.

I think we can simply start with a module parameter for VDUSE?


>   and so on for this emulated device. Then
> +a char device interface (/dev/vduse/$NAME) is exported to userspace for device
> +emulation. Userspace can use the VDUSE_VQ_SETUP ioctl on /dev/vduse/$NAME to
> +add per-virtqueue configuration such as the max size of virtqueue to the device.
> +
> +After the initialization, the VDUSE device can be attached to vDPA bus via
> +the VDPA_CMD_DEV_NEW netlink message. Userspace needs to read()/write() on
> +/dev/vduse/$NAME to receive/reply some control messages from/to VDUSE kernel
> +module as follows:
> +
> +.. code-block:: c
> +
> +	static int vduse_message_handler(int dev_fd)
> +	{
> +		int len;
> +		struct vduse_dev_request req;
> +		struct vduse_dev_response resp;
> +
> +		len = read(dev_fd, &req, sizeof(req));
> +		if (len != sizeof(req))
> +			return -1;
> +
> +		resp.request_id = req.request_id;
> +
> +		switch (req.type) {
> +
> +		/* handle different types of message */


"messages"?


> +
> +		}
> +
> +		len = write(dev_fd, &resp, sizeof(resp));
> +		if (len != sizeof(resp))
> +			return -1;
> +
> +		return 0;
> +	}
> +
> +There are now three types of messages introduced by VDUSE framework:
> +
> +- VDUSE_GET_VQ_STATE: Get the state for virtqueue, userspace should return
> +  avail index for split virtqueue or the device/driver ring wrap counters and
> +  the avail and used index for packed virtqueue.
> +
> +- VDUSE_SET_STATUS: Set the device status, userspace should follow
> +  the virtio spec: https://docs.oasis-open.org/virtio/virtio/v1.1/virtio-v1.1.html
> +  to process this message. For example, fail to set the FEATURES_OK device
> +  status bit if the device can not accept the negotiated virtio features
> +  get from the VDUSE_GET_FEATURES ioctl.
> +
> +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping for specified
> +  IOVA range, userspace should firstly remove the old mapping, then setup the new
> +  mapping via the VDUSE_IOTLB_GET_FD ioctl.
> +
> +After DRIVER_OK status bit is set via the VDUSE_SET_STATUS message, userspace is
> +able to start the dataplane processing with the help of below ioctls:
> +
> +- VDUSE_IOTLB_GET_FD: Find the first IOVA region that overlaps with the specified
> +  range [start, last] and return the corresponding file descriptor. In vhost-vdpa
> +  cases, it might be a full chunk of guest RAM. And in virtio-vdpa cases, it should
> +  be the whole bounce buffer or the memory region that stores one virtqueue's
> +  metadata (descriptor table, available ring and used ring).


I think we can simply remove the driver specific sentences. And just say 
to use map the pages to the IOVA.


> Userspace can access
> +  this IOVA region by passing fd and corresponding size, offset, perm to mmap().
> +  For example:
> +
> +.. code-block:: c
> +
> +	static int perm_to_prot(uint8_t perm)
> +	{
> +		int prot = 0;
> +
> +		switch (perm) {
> +		case VDUSE_ACCESS_WO:
> +			prot |= PROT_WRITE;
> +			break;
> +		case VDUSE_ACCESS_RO:
> +			prot |= PROT_READ;
> +			break;
> +		case VDUSE_ACCESS_RW:
> +			prot |= PROT_READ | PROT_WRITE;
> +			break;
> +		}
> +
> +		return prot;
> +	}
> +
> +	static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
> +	{
> +		int fd;
> +		void *addr;
> +		size_t size;
> +		struct vduse_iotlb_entry entry;
> +
> +		entry.start = iova;
> +		entry.last = iova;
> +		fd = ioctl(dev_fd, VDUSE_IOTLB_GET_FD, &entry);
> +		if (fd < 0)
> +			return NULL;
> +
> +		size = entry.last - entry.start + 1;
> +		*len = entry.last - iova + 1;
> +		addr = mmap(0, size, perm_to_prot(entry.perm), MAP_SHARED,
> +			    fd, entry.offset);
> +		close(fd);
> +		if (addr == MAP_FAILED)
> +			return NULL;
> +
> +		/*
> +		 * Using some data structures such as linked list to store
> +		 * the iotlb mapping. The munmap(2) should be called for the
> +		 * cached mapping when the corresponding VDUSE_UPDATE_IOTLB
> +		 * message is received or the device is reset.
> +		 */
> +
> +		return addr + iova - entry.start;
> +	}
> +
> +- VDUSE_VQ_GET_INFO: Get the specified virtqueue's information including the size,
> +  the IOVAs of descriptor table, available ring and used ring, the state
> +  and the ready status.


Maybe it's better just show the  vduse_vq_info here, or both. (maybe we 
can do the same for the rest of ioctls).


> The IOVAs should be passed to the VDUSE_IOTLB_GET_FD ioctl
> +  so that userspace can access the descriptor table, available ring and used ring.
> +
> +- VDUSE_VQ_SETUP_KICKFD: Setup the kick eventfd for the specified virtqueues.
> +  The kick eventfd is used by VDUSE kernel module to notify userspace to consume
> +  the available ring.
> +
> +- VDUSE_INJECT_VQ_IRQ: Inject an interrupt for specific virtqueue. It's used to
> +  notify virtio driver to consume the used ring.


The config interrupt injection is missed.


> +
> +More details on the uAPI can be found in include/uapi/linux/vduse.h.
> +
> +MMU-based IOMMU Driver
> +----------------------
> +


It's kind of software IOTLB actually. Maybe we can call that "MMU-based 
software IOTLB"


> +VDUSE framework implements an MMU-based on-chip IOMMU driver to support
> +mapping the kernel DMA buffer into the userspace IOVA region dynamically.
> +This is mainly designed for virtio-vdpa case (kernel virtio drivers).
> +
> +The basic idea behind this driver is treating MMU (VA->PA) as IOMMU (IOVA->PA).
> +The driver will set up MMU mapping instead of IOMMU mapping for the DMA transfer
> +so that the userspace process is able to use its virtual address to access
> +the DMA buffer in kernel.
> +
> +And to avoid security issue, a bounce-buffering mechanism is introduced to
> +prevent userspace accessing the original buffer directly which may contain other
> +kernel data.


I wonder if it's worth to describe the method we used for guarding 
against malicious userspace device.

Thanks


>   During the mapping, unmapping, the driver will copy the data from
> +the original buffer to the bounce buffer and back, depending on the direction of
> +the transfer. And the bounce-buffer addresses will be mapped into the user address
> +space instead of the original one.

