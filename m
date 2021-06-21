Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEEA3AF1D4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhFUR0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFUR0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:26:46 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98673C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:24:31 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id x196so20684809oif.10
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKmGjgLsgWsFBaBePs7cjUDuoclC/CKZFAJTnQ9AJMs=;
        b=JlwDd3p+9HGTZoM82mSEcGnLlu8sxR3GFo+ou3kNhT/FgSBJWjVVZksAYHD9snLqOW
         t4C02M5/JrwhTMk0Ev8rvYIabC2Kk6bjAVy059EXiCL2dezvvxDtrmkWTkGi4vCDbWf9
         10M+9Rvbtotts+rFzzKWY3IdBrJcr3HgL6eIb2GLAnjpqwz7X6bKHUWsDLSykTY/APoy
         GOJfjWZqf5htG0uaZNLWmE56Sbo4iGBftsw6p6kURUVn2AaOcKkjBpADwWPqaN1VoU1l
         d6j9JDM00UGUKbyIhm34TdmSz7EmZ733coZcUYgYB3DhkA2ErfjYDiAm4Ta/fblght9t
         cE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKmGjgLsgWsFBaBePs7cjUDuoclC/CKZFAJTnQ9AJMs=;
        b=VPjmwYPR5kIbhnbEfMyHEu20KSnCHMm38hYr/JjogGZ45PfjSO2ghrSQAj1hgq63EK
         hPSii1VOJ7JqwSJ2PuFc9bOenh26zO6JmTT0nLnrw2cpoWD1sdKCiZvkIo5TB04h+jdy
         nfiEZsgpRcfy2cPVg46ZebbHZRy0jxjN1fFLc1Q76cR/K6EtNGlm109pVSsh3LAQa4LF
         mqHpzTnGdGoINjzxRVVwAzenyQMLh4DSiu+rkER5KbiFfbKUEgiLaqsaW8Z7n5Ab1YXg
         apbt2j49lKYcaB2bmgiKT6TeeRZvIlTyKfxVbq6vdqFw41U0J+Z0EMp1HoAoeQ+XMod2
         5DIQ==
X-Gm-Message-State: AOAM533B1b1v0YNhbsELz+0dr6QCOFSg6GOjbjeyHTo/8UMYiqJRp8pv
        Zg+vC7a2H3dgadnXFopHFZyzZFpQF6wr2rzcBX76lg==
X-Google-Smtp-Source: ABdhPJwwgSJtHVHbFJBIgtqJtkqt3r/pism6TPjHvnMbCkspkHQPBTtNGkFsBzAo/tU1Xi57+G30U2wnqoV1LIX+Saw=
X-Received: by 2002:aca:e0d6:: with SMTP id x205mr17923656oig.109.1624296271029;
 Mon, 21 Jun 2021 10:24:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-2-jiang.wang@bytedance.com> <20210618093951.g32htj3rsu2koqi5@steredhat.lan>
In-Reply-To: <20210618093951.g32htj3rsu2koqi5@steredhat.lan>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 21 Jun 2021 10:24:20 -0700
Message-ID: <CAP_N_Z-vom-8=Otjtt9wndP8KLDvy7KxQg20g4=65Y4d8N7CmA@mail.gmail.com>
Subject: Re: [External] Re: [RFC v1 1/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM
 feature bit
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 2:40 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Wed, Jun 09, 2021 at 11:24:53PM +0000, Jiang Wang wrote:
> >When this feature is enabled, allocate 5 queues,
> >otherwise, allocate 3 queues to be compatible with
> >old QEMU versions.
> >
> >Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >---
> > drivers/vhost/vsock.c             |  3 +-
> > include/linux/virtio_vsock.h      |  9 +++++
> > include/uapi/linux/virtio_vsock.h |  3 ++
> > net/vmw_vsock/virtio_transport.c  | 73 +++++++++++++++++++++++++++++++++++----
> > 4 files changed, 80 insertions(+), 8 deletions(-)
> >
> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >index 5e78fb719602..81d064601093 100644
> >--- a/drivers/vhost/vsock.c
> >+++ b/drivers/vhost/vsock.c
> >@@ -31,7 +31,8 @@
> >
> > enum {
> >       VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> >-                             (1ULL << VIRTIO_F_ACCESS_PLATFORM)
> >+                             (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> >+                             (1ULL << VIRTIO_VSOCK_F_DGRAM)
> > };
> >
> > enum {
> >diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> >index dc636b727179..ba3189ed9345 100644
> >--- a/include/linux/virtio_vsock.h
> >+++ b/include/linux/virtio_vsock.h
> >@@ -18,6 +18,15 @@ enum {
> >       VSOCK_VQ_MAX    = 3,
> > };
> >
> >+enum {
> >+      VSOCK_VQ_STREAM_RX     = 0, /* for host to guest data */
> >+      VSOCK_VQ_STREAM_TX     = 1, /* for guest to host data */
> >+      VSOCK_VQ_DGRAM_RX       = 2,
> >+      VSOCK_VQ_DGRAM_TX       = 3,
> >+      VSOCK_VQ_EX_EVENT       = 4,
> >+      VSOCK_VQ_EX_MAX         = 5,
> >+};
> >+
> > /* Per-socket state (accessed via vsk->trans) */
> > struct virtio_vsock_sock {
> >       struct vsock_sock *vsk;
> >diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> >index 1d57ed3d84d2..b56614dff1c9 100644
> >--- a/include/uapi/linux/virtio_vsock.h
> >+++ b/include/uapi/linux/virtio_vsock.h
> >@@ -38,6 +38,9 @@
> > #include <linux/virtio_ids.h>
> > #include <linux/virtio_config.h>
> >
> >+/* The feature bitmap for virtio net */
> >+#define VIRTIO_VSOCK_F_DGRAM  0       /* Host support dgram vsock */
> >+
> > struct virtio_vsock_config {
> >       __le64 guest_cid;
> > } __attribute__((packed));
> >diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >index 2700a63ab095..7dcb8db23305 100644
> >--- a/net/vmw_vsock/virtio_transport.c
> >+++ b/net/vmw_vsock/virtio_transport.c
> >@@ -27,7 +27,8 @@ static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
> >
> > struct virtio_vsock {
> >       struct virtio_device *vdev;
> >-      struct virtqueue *vqs[VSOCK_VQ_MAX];
> >+      struct virtqueue **vqs;
> >+      bool has_dgram;
> >
> >       /* Virtqueue processing is deferred to a workqueue */
> >       struct work_struct tx_work;
> >@@ -333,7 +334,10 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
> >       struct scatterlist sg;
> >       struct virtqueue *vq;
> >
> >-      vq = vsock->vqs[VSOCK_VQ_EVENT];
> >+      if (vsock->has_dgram)
> >+              vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
> >+      else
> >+              vq = vsock->vqs[VSOCK_VQ_EVENT];
> >
> >       sg_init_one(&sg, event, sizeof(*event));
> >
> >@@ -351,7 +355,10 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> >               virtio_vsock_event_fill_one(vsock, event);
> >       }
> >
> >-      virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> >+      if (vsock->has_dgram)
> >+              virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
> >+      else
> >+              virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> > }
> >
> > static void virtio_vsock_reset_sock(struct sock *sk)
> >@@ -391,7 +398,10 @@ static void virtio_transport_event_work(struct work_struct *work)
> >               container_of(work, struct virtio_vsock, event_work);
> >       struct virtqueue *vq;
> >
> >-      vq = vsock->vqs[VSOCK_VQ_EVENT];
> >+      if (vsock->has_dgram)
> >+              vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
> >+      else
> >+              vq = vsock->vqs[VSOCK_VQ_EVENT];
> >
> >       mutex_lock(&vsock->event_lock);
> >
> >@@ -411,7 +421,10 @@ static void virtio_transport_event_work(struct work_struct *work)
> >               }
> >       } while (!virtqueue_enable_cb(vq));
> >
> >-      virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> >+      if (vsock->has_dgram)
> >+              virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
> >+      else
> >+              virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> > out:
> >       mutex_unlock(&vsock->event_lock);
> > }
> >@@ -434,6 +447,10 @@ static void virtio_vsock_tx_done(struct virtqueue *vq)
> >       queue_work(virtio_vsock_workqueue, &vsock->tx_work);
> > }
> >
> >+static void virtio_vsock_dgram_tx_done(struct virtqueue *vq)
> >+{
> >+}
> >+
> > static void virtio_vsock_rx_done(struct virtqueue *vq)
> > {
> >       struct virtio_vsock *vsock = vq->vdev->priv;
> >@@ -443,6 +460,10 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> >       queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> > }
> >
> >+static void virtio_vsock_dgram_rx_done(struct virtqueue *vq)
> >+{
> >+}
> >+
> > static struct virtio_transport virtio_transport = {
> >       .transport = {
> >               .module                   = THIS_MODULE,
> >@@ -545,13 +566,29 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> >               virtio_vsock_tx_done,
> >               virtio_vsock_event_done,
> >       };
> >+      vq_callback_t *ex_callbacks[] = {
>
> 'ex' is not clear, maybe better 'dgram'?
>
sure.

> What happen if F_DGRAM is negotiated, but not F_STREAM?
>
Hmm. In my mind, F_STREAM is always negotiated. Do we want to add
support when F_STREAM is not negotiated?

> >+              virtio_vsock_rx_done,
> >+              virtio_vsock_tx_done,
> >+              virtio_vsock_dgram_rx_done,
> >+              virtio_vsock_dgram_tx_done,
> >+              virtio_vsock_event_done,
> >+      };
> >+
> >       static const char * const names[] = {
> >               "rx",
> >               "tx",
> >               "event",
> >       };
> >+      static const char * const ex_names[] = {
> >+              "rx",
> >+              "tx",
> >+              "dgram_rx",
> >+              "dgram_tx",
> >+              "event",
> >+      };
> >+
> >       struct virtio_vsock *vsock = NULL;
> >-      int ret;
> >+      int ret, max_vq;
> >
> >       ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
> >       if (ret)
> >@@ -572,9 +609,30 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> >
> >       vsock->vdev = vdev;
> >
> >-      ret = virtio_find_vqs(vsock->vdev, VSOCK_VQ_MAX,
> >+      if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
> >+              vsock->has_dgram = true;
> >+
> >+      if (vsock->has_dgram)
> >+              max_vq = VSOCK_VQ_EX_MAX;
> >+      else
> >+              max_vq = VSOCK_VQ_MAX;
> >+
> >+      vsock->vqs = kmalloc_array(max_vq, sizeof(struct virtqueue *), GFP_KERNEL);
> >+      if (!vsock->vqs) {
> >+              ret = -ENOMEM;
> >+              goto out;
> >+      }
> >+
> >+      if (vsock->has_dgram) {
> >+              ret = virtio_find_vqs(vsock->vdev, max_vq,
> >+                            vsock->vqs, ex_callbacks, ex_names,
> >+                            NULL);
> >+      } else {
> >+              ret = virtio_find_vqs(vsock->vdev, max_vq,
> >                             vsock->vqs, callbacks, names,
> >                             NULL);
> >+      }
> >+
> >       if (ret < 0)
> >               goto out;
> >
> >@@ -695,6 +753,7 @@ static struct virtio_device_id id_table[] = {
> > };
> >
> > static unsigned int features[] = {
> >+      VIRTIO_VSOCK_F_DGRAM,
> > };
> >
> > static struct virtio_driver virtio_vsock_driver = {
> >--
> >2.11.0
> >
>
