Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76F43DE73F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 09:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhHCHfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 03:35:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234123AbhHCHfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 03:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627976132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZpG8qZ893j1o8sn8JV/ZwWeTuYDoTYmM90wiNM5428=;
        b=d9K0eYJI4JLnw3/dsc5yxP5omt7NnsO+xAXm7PWSdhS7qYsLq7E3BS7T3oCF8M3f95gAJO
        BZamR48IJrumhJneHIru4skFERvYnbtoiUIoLJFUK5eHHk/X7hQgYgrzFSVJRXRSV/p2Nb
        6RffO95S2XZO3gqhM9UYGzpCFJLDAwY=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Hjpr6J5CO2WFHrMZy2a2JQ-1; Tue, 03 Aug 2021 03:35:31 -0400
X-MC-Unique: Hjpr6J5CO2WFHrMZy2a2JQ-1
Received: by mail-pl1-f200.google.com with SMTP id w19-20020a170902d113b029012c1505a89fso8216560plw.13
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 00:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mZpG8qZ893j1o8sn8JV/ZwWeTuYDoTYmM90wiNM5428=;
        b=khmF4jbRnsrH+djpu+zF8jCMbATjVuq/Iem6faFAinkD96ezLiO7j/jpCVKdYDPrOy
         MYYD/2sdpd1m2bl8tgoqeVGuamuHo/7zQTOvREtPZwmZrSiGX8YAKpTlKfbO9Ahd9BbN
         rL7hk0rgUELU6g0tuvk2ATf53i2HtKmiFea+Tbmcqsj8g0YB3k9aJEyvrlyVx3Lk9PcN
         tO+O63tT+Eh9dXbVrntwF93dJg6Z4c0zM55rr05grhNCoeq6Joefw+4l4KSy/yxgU7+i
         KaDvcUPyyr2gpI7HrB22J+QB/onbgPu3ow2ETTRZU8Rfa/Hf7wyYvZhTpF/xeHa/DHjh
         a7iw==
X-Gm-Message-State: AOAM531M7X56H7xc3DjrlkTmFtP7WwGou/euc3NsDbtcTVQYPUS6cvXF
        FZK2A+fH2WyXZsbN20f2MZHRK+8EPu2Luz9iOtOVggnr6N/jHHBhA/s+28BvJqFwFfazHagkebM
        kUaVsjhwKVBzAZWCw
X-Received: by 2002:a17:902:aa82:b029:12c:6463:4880 with SMTP id d2-20020a170902aa82b029012c64634880mr17469376plr.65.1627976130006;
        Tue, 03 Aug 2021 00:35:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzDMaQcIOIpmMckH/ZOtIpriUh01WThBYUtuU4942UPCJ7bwzpd6VLmbVHKx9AtSYCiMLzIyA==
X-Received: by 2002:a17:902:aa82:b029:12c:6463:4880 with SMTP id d2-20020a170902aa82b029012c64634880mr17469348plr.65.1627976129721;
        Tue, 03 Aug 2021 00:35:29 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h7sm11648301pjs.38.2021.08.03.00.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 00:35:28 -0700 (PDT)
Subject: Re: [PATCH v10 17/17] Documentation: Add documentation for VDUSE
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-18-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <05365f36-bc3a-40f4-764d-37a7249b94b1@redhat.com>
Date:   Tue, 3 Aug 2021 15:35:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729073503.187-18-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/29 ÏÂÎç3:35, Xie Yongji Ð´µÀ:
> VDUSE (vDPA Device in Userspace) is a framework to support
> implementing software-emulated vDPA devices in userspace. This
> document is intended to clarify the VDUSE design and usage.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   Documentation/userspace-api/index.rst |   1 +
>   Documentation/userspace-api/vduse.rst | 232 ++++++++++++++++++++++++++++++++++
>   2 files changed, 233 insertions(+)
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
> index 000000000000..30c9d1482126
> --- /dev/null
> +++ b/Documentation/userspace-api/vduse.rst
> @@ -0,0 +1,232 @@
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
> +Create/Destroy VDUSE devices
> +------------------------
> +
> +VDUSE devices are created as follows:
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
> +
> +VDUSE devices are destroyed as follows:
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
> +configuration space, the number of virtqueues and so on for this emulated device.
> +Then a char device interface (/dev/vduse/$NAME) is exported to userspace for device
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
> +		/* handle different types of messages */
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
> +  get from the VDUSE_DEV_GET_FEATURES ioctl.


I wonder if it's better to add a section about the future work?

E.g the support for the userspace device to modify status (like 
NEEDS_RESET).


> +
> +- VDUSE_UPDATE_IOTLB: Notify userspace to update the memory mapping for specified
> +  IOVA range, userspace should firstly remove the old mapping, then setup the new
> +  mapping via the VDUSE_IOTLB_GET_FD ioctl.
> +
> +After DRIVER_OK status bit is set via the VDUSE_SET_STATUS message, userspace is
> +able to start the dataplane processing as follows:
> +
> +1. Get the specified virtqueue's information with the VDUSE_VQ_GET_INFO ioctl,
> +   including the size, the IOVAs of descriptor table, available ring and used ring,
> +   the state and the ready status.
> +
> +2. Pass the above IOVAs to the VDUSE_IOTLB_GET_FD ioctl so that those IOVA regions
> +   can be mapped into userspace. Some sample codes is shown below:
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
> +
> +		/*
> +		 * Find the first IOVA region that overlaps with the specified
> +		 * range [start, last] and return the corresponding file descriptor.
> +		 */
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
> +3. Setup the kick eventfd for the specified virtqueues with the VDUSE_VQ_SETUP_KICKFD
> +   ioctl. The kick eventfd is used by VDUSE kernel module to notify userspace to
> +   consume the available ring.
> +
> +4. Listen to the kick eventfd and consume the available ring. The buffer described
> +   by the descriptors in the descriptor table should be also mapped into userspace
> +   via the VDUSE_IOTLB_GET_FD ioctl before accessing.


(Or userspace may poll the indices instead, the kick eventfd is not a must).


Thanks


> +
> +5. Inject an interrupt for specific virtqueue with the VDUSE_INJECT_VQ_IRQ ioctl
> +   after the used ring is filled.
> +
> +For more details on the uAPI, please see include/uapi/linux/vduse.h.

