Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B433D3962C5
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhEaPA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbhEaO7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:59:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4CAC014CB4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:02:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id u24so4090605edy.11
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 07:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g6KE7qxJkSlFrye+cGyIzYWa5dPIDL/EU1aNcbuAXSk=;
        b=o8DCX0SFOhF+XHBSaWZtNvmdQJJirIn0b6k9GM0J33PbaX5Yprc+wKQ4a0Ui7yNZCr
         hEMqn1M78U6odCXDEHzYc1rwLJihz4w8HO9U9/OCRZhMqAAjU3T6lw/eO6DL7b+W4XkX
         4r1nz3O5ScEaJ5SmTN/w9TgHNLLK4tLAGwkBqiFBwO3uBf+329r4ZkVA/9WkfnLUtFcb
         M3WE/gT4Mr3c9lQuMdMNEu4Qh/voXIklxuvjjeb9rGAqRODsbF6XzNn+jhFibqnjdAbA
         qKwVvHascY6SMWp7A0cya61Z5X+IWLAtHZqfJ75qYcNnd3RJcY4G6rMl/29HiIDiReBM
         feJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g6KE7qxJkSlFrye+cGyIzYWa5dPIDL/EU1aNcbuAXSk=;
        b=HnnrB1zfp2vjP2x1tKN2gsEqxPLiPfNQuFNKOhaeHuRoBuASjUJcsVHxbZc7iO4fsG
         /MHW5773k8GipBYlWmL/WH2FzZ0IWqIhoCxtjqdymS4DBSwQgVxd3IPjLIwhqIf6IsXe
         8pasbwWHxLsZH2hIiUCCXp1mYv/2Ynb1NhuQZReJHaoY/SpS8aLR9F9Whkvyha8LI5aQ
         lH6p4APM/oSGvx9ryfTvDIJ4beE+I27Hx7S9Fdr3XW4k1PZxMEcxAUFj0Xi/r2K+cxqT
         E+Rz3hHfDUi9aZtD/jJRWKctfdM74aeW+FmoG3hcNOSaEwfzkEVFPgodKDqCNb64xGLe
         x7YQ==
X-Gm-Message-State: AOAM533fsQKoP+gvK7MjB01PdEZyhZtuSqyh9Aivl0eBx1hAHnp1KwD+
        dUEYLzaRjXZFskWq6RgJgDU3rgf6qciXwjfDecM=
X-Google-Smtp-Source: ABdhPJzDOg2GFrwdwd+zbbJdYg6mXV6XqIe75m9RAA9kPedXqPTdeuZsc8lH/tbJAfnoFCW+V0Rk+oOWZs+rvYnw/3A=
X-Received: by 2002:a05:6402:50c6:: with SMTP id h6mr25722171edb.327.1622469747571;
 Mon, 31 May 2021 07:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210527235902.2185-1-smalin@marvell.com> <20210527235902.2185-6-smalin@marvell.com>
 <0fa12e28-63e3-2404-2ede-2b2647786ccf@suse.de>
In-Reply-To: <0fa12e28-63e3-2404-2ede-2b2647786ccf@suse.de>
From:   Shai Malin <malin1024@gmail.com>
Date:   Mon, 31 May 2021 17:02:15 +0300
Message-ID: <CAKKgK4yrVRJ4+QuOQfFrFf28d=3O1+-4LJ9iQuE_OFWRtMkZtQ@mail.gmail.com>
Subject: Re: [RFC PATCH v6 05/27] nvme-tcp-offload: Add controller level implementation
To:     Hannes Reinecke <hare@suse.de>
Cc:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, Arie Gershberg <agershberg@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 2:21 PM, Hannes Reinecke wrote:
> On 5/28/21 1:58 AM, Shai Malin wrote:
> > From: Arie Gershberg <agershberg@marvell.com>
> >
> > In this patch we implement controller level functionality including:
> > - create_ctrl.
> > - delete_ctrl.
> > - free_ctrl.
> >
> > The implementation is similar to other nvme fabrics modules, the main
> > difference being that the nvme-tcp-offload ULP calls the vendor specifi=
c
> > claim_dev() op with the given TCP/IP parameters to determine which devi=
ce
> > will be used for this controller.
> > Once found, the vendor specific device and controller will be paired an=
d
> > kept in a controller list managed by the ULP.
> >
> > Acked-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Arie Gershberg <agershberg@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> > Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> > ---
> >  drivers/nvme/host/tcp-offload.c | 481 +++++++++++++++++++++++++++++++-
> >  1 file changed, 476 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-of=
fload.c
> > index e602801d43d3..9b2ae54a2679 100644
> > --- a/drivers/nvme/host/tcp-offload.c
> > +++ b/drivers/nvme/host/tcp-offload.c
> > @@ -12,6 +12,10 @@
> >
> >  static LIST_HEAD(nvme_tcp_ofld_devices);
> >  static DEFINE_MUTEX(nvme_tcp_ofld_devices_mutex);
> > +static LIST_HEAD(nvme_tcp_ofld_ctrl_list);
> > +static DEFINE_MUTEX(nvme_tcp_ofld_ctrl_mutex);
> > +static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops;
> > +static struct blk_mq_ops nvme_tcp_ofld_mq_ops;
> >
> >  static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_=
ctrl *nctrl)
> >  {
> > @@ -119,21 +123,439 @@ nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ct=
rl *ctrl)
> >       return dev;
> >  }
> >
> > +static struct blk_mq_tag_set *
> > +nvme_tcp_ofld_alloc_tagset(struct nvme_ctrl *nctrl, bool admin)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct blk_mq_tag_set *set;
> > +     int rc;
> > +
> > +     if (admin) {
> > +             set =3D &ctrl->admin_tag_set;
> > +             memset(set, 0, sizeof(*set));
> > +             set->ops =3D &nvme_tcp_ofld_admin_mq_ops;
> > +             set->queue_depth =3D NVME_AQ_MQ_TAG_DEPTH;
> > +             set->reserved_tags =3D NVMF_RESERVED_TAGS;
> > +             set->numa_node =3D nctrl->numa_node;
> > +             set->flags =3D BLK_MQ_F_BLOCKING;
> > +             set->cmd_size =3D sizeof(struct nvme_tcp_ofld_req);
> > +             set->driver_data =3D ctrl;
> > +             set->nr_hw_queues =3D 1;
> > +             set->timeout =3D NVME_ADMIN_TIMEOUT;
> > +     } else {
> > +             set =3D &ctrl->tag_set;
> > +             memset(set, 0, sizeof(*set));
> > +             set->ops =3D &nvme_tcp_ofld_mq_ops;
> > +             set->queue_depth =3D nctrl->sqsize + 1;
> > +             set->reserved_tags =3D NVMF_RESERVED_TAGS;
> > +             set->numa_node =3D nctrl->numa_node;
> > +             set->flags =3D BLK_MQ_F_SHOULD_MERGE;
> > +             set->cmd_size =3D sizeof(struct nvme_tcp_ofld_req);
> > +             set->driver_data =3D ctrl;
> > +             set->nr_hw_queues =3D nctrl->queue_count - 1;
> > +             set->timeout =3D NVME_IO_TIMEOUT;
> > +             set->nr_maps =3D nctrl->opts->nr_poll_queues ? HCTX_MAX_T=
YPES : 2;
> > +     }
> > +
> > +     rc =3D blk_mq_alloc_tag_set(set);
> > +     if (rc)
> > +             return ERR_PTR(rc);
> > +
> > +     return set;
> > +}
> > +
> > +static int nvme_tcp_ofld_configure_admin_queue(struct nvme_ctrl *nctrl=
,
> > +                                            bool new)
> > +{
> > +     int rc;
> > +
> > +     /* Placeholder - alloc_admin_queue */
> > +     if (new) {
> > +             nctrl->admin_tagset =3D
> > +                             nvme_tcp_ofld_alloc_tagset(nctrl, true);
> > +             if (IS_ERR(nctrl->admin_tagset)) {
> > +                     rc =3D PTR_ERR(nctrl->admin_tagset);
> > +                     nctrl->admin_tagset =3D NULL;
> > +                     goto out_destroy_queue;
> > +             }
> > +
> > +             nctrl->fabrics_q =3D blk_mq_init_queue(nctrl->admin_tagse=
t);
> > +             if (IS_ERR(nctrl->fabrics_q)) {
> > +                     rc =3D PTR_ERR(nctrl->fabrics_q);
> > +                     nctrl->fabrics_q =3D NULL;
> > +                     goto out_free_tagset;
> > +             }
> > +
> > +             nctrl->admin_q =3D blk_mq_init_queue(nctrl->admin_tagset)=
;
> > +             if (IS_ERR(nctrl->admin_q)) {
> > +                     rc =3D PTR_ERR(nctrl->admin_q);
> > +                     nctrl->admin_q =3D NULL;
> > +                     goto out_cleanup_fabrics_q;
> > +             }
> > +     }
> > +
> > +     /* Placeholder - nvme_tcp_ofld_start_queue */
> > +
> > +     rc =3D nvme_enable_ctrl(nctrl);
> > +     if (rc)
> > +             goto out_stop_queue;
> > +
> > +     blk_mq_unquiesce_queue(nctrl->admin_q);
> > +
> > +     rc =3D nvme_init_ctrl_finish(nctrl);
> > +     if (rc)
> > +             goto out_quiesce_queue;
> > +
> > +     return 0;
> > +
> > +out_quiesce_queue:
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     blk_sync_queue(nctrl->admin_q);
> > +
> > +out_stop_queue:
> > +     /* Placeholder - stop offload queue */
> > +     nvme_cancel_admin_tagset(nctrl);
> > +
> > +out_cleanup_fabrics_q:
> > +     if (new)
> > +             blk_cleanup_queue(nctrl->fabrics_q);
> > +out_free_tagset:
> > +     if (new)
> > +             blk_mq_free_tag_set(nctrl->admin_tagset);
> > +out_destroy_queue:
> > +     /* Placeholder - free admin queue */
> > +
> > +     return rc;
> > +}
> > +
> > +static int
> > +nvme_tcp_ofld_configure_io_queues(struct nvme_ctrl *nctrl, bool new)
> > +{
> > +     int rc;
> > +
> > +     /* Placeholder - alloc_io_queues */
> > +
> > +     if (new) {
> > +             nctrl->tagset =3D nvme_tcp_ofld_alloc_tagset(nctrl, false=
);
> > +             if (IS_ERR(nctrl->tagset)) {
> > +                     rc =3D PTR_ERR(nctrl->tagset);
> > +                     nctrl->tagset =3D NULL;
> > +                     goto out_free_io_queues;
> > +             }
> > +
> > +             nctrl->connect_q =3D blk_mq_init_queue(nctrl->tagset);
> > +             if (IS_ERR(nctrl->connect_q)) {
> > +                     rc =3D PTR_ERR(nctrl->connect_q);
> > +                     nctrl->connect_q =3D NULL;
> > +                     goto out_free_tag_set;
> > +             }
> > +     }
> > +
> > +     /* Placeholder - start_io_queues */
> > +
> > +     if (!new) {
> > +             nvme_start_queues(nctrl);
> > +             if (!nvme_wait_freeze_timeout(nctrl, NVME_IO_TIMEOUT)) {
> > +                     /*
> > +                      * If we timed out waiting for freeze we are like=
ly to
> > +                      * be stuck.  Fail the controller initialization =
just
> > +                      * to be safe.
> > +                      */
> > +                     rc =3D -ENODEV;
> > +                     goto out_wait_freeze_timed_out;
> > +             }
> > +             blk_mq_update_nr_hw_queues(nctrl->tagset, nctrl->queue_co=
unt - 1);
> > +             nvme_unfreeze(nctrl);
> > +     }
> > +
> > +     return 0;
> > +
> > +out_wait_freeze_timed_out:
> > +     nvme_stop_queues(nctrl);
> > +     nvme_sync_io_queues(nctrl);
> > +
> > +     /* Placeholder - Stop IO queues */
> > +
> > +     if (new)
> > +             blk_cleanup_queue(nctrl->connect_q);
> > +out_free_tag_set:
> > +     if (new)
> > +             blk_mq_free_tag_set(nctrl->tagset);
> > +out_free_io_queues:
> > +     /* Placeholder - free_io_queues */
> > +
> > +     return rc;
> > +}
> > +
> > +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvmf_ctrl_options *opts =3D nctrl->opts;
> > +     int rc =3D 0;
> > +
> > +     rc =3D ctrl->dev->ops->setup_ctrl(ctrl);
> > +     if (rc)
> > +             return rc;
> > +
> > +     rc =3D nvme_tcp_ofld_configure_admin_queue(nctrl, new);
> > +     if (rc)
> > +             goto out_release_ctrl;
> > +
> > +     if (nctrl->icdoff) {
> > +             dev_err(nctrl->device, "icdoff is not supported!\n");
> > +             rc =3D -EINVAL;
> > +             goto destroy_admin;
> > +     }
> > +
> > +     if (!(nctrl->sgls & ((1 << 0) | (1 << 1)))) {
> > +             dev_err(nctrl->device, "Mandatory sgls are not supported!=
\n");
> > +             goto destroy_admin;
> > +     }
> > +
> > +     if (opts->queue_size > nctrl->sqsize + 1)
> > +             dev_warn(nctrl->device,
> > +                      "queue_size %zu > ctrl sqsize %u, clamping down\=
n",
> > +                      opts->queue_size, nctrl->sqsize + 1);
> > +
> > +     if (nctrl->sqsize + 1 > nctrl->maxcmd) {
> > +             dev_warn(nctrl->device,
> > +                      "sqsize %u > ctrl maxcmd %u, clamping down\n",
> > +                      nctrl->sqsize + 1, nctrl->maxcmd);
> > +             nctrl->sqsize =3D nctrl->maxcmd - 1;
> > +     }
> > +
> > +     if (nctrl->queue_count > 1) {
> > +             rc =3D nvme_tcp_ofld_configure_io_queues(nctrl, new);
> > +             if (rc)
> > +                     goto destroy_admin;
> > +     }
> > +
> > +     if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_LIVE)) {
> > +             /*
> > +              * state change failure is ok if we started ctrl delete,
> > +              * unless we're during creation of a new controller to
> > +              * avoid races with teardown flow.
> > +              */
> > +             WARN_ON_ONCE(nctrl->state !=3D NVME_CTRL_DELETING &&
> > +                          nctrl->state !=3D NVME_CTRL_DELETING_NOIO);
> > +             WARN_ON_ONCE(new);
> > +             rc =3D -EINVAL;
> > +             goto destroy_io;
> > +     }
> > +
> > +     nvme_start_ctrl(nctrl);
> > +
> > +     return 0;
> > +
> > +destroy_io:
> > +     /* Placeholder - stop and destroy io queues*/
> > +destroy_admin:
> > +     /* Placeholder - stop and destroy admin queue*/
> > +out_release_ctrl:
> > +     ctrl->dev->ops->release_ctrl(ctrl);
> > +
> > +     return rc;
> > +}
> > +
> > +static int
> > +nvme_tcp_ofld_check_dev_opts(struct nvmf_ctrl_options *opts,
> > +                          struct nvme_tcp_ofld_ops *ofld_ops)
> > +{
> > +     unsigned int nvme_tcp_ofld_opt_mask =3D NVMF_ALLOWED_OPTS |
> > +                     ofld_ops->allowed_opts | ofld_ops->required_opts;
> > +     struct nvmf_ctrl_options dev_opts_mask;
> > +
> > +     if (opts->mask & ~nvme_tcp_ofld_opt_mask) {
> > +             pr_warn("One or more nvmf options missing from ofld drvr =
%s.\n",
> > +                     ofld_ops->name);
> > +
> > +             dev_opts_mask.mask =3D nvme_tcp_ofld_opt_mask;
> > +
> > +             return nvmf_check_required_opts(&dev_opts_mask, opts->mas=
k);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void nvme_tcp_ofld_free_ctrl(struct nvme_ctrl *nctrl)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl =3D to_tcp_ofld_ctrl(nctrl);
> > +     struct nvme_tcp_ofld_dev *dev =3D ctrl->dev;
> > +
> > +     if (list_empty(&ctrl->list))
> > +             goto free_ctrl;
> > +
> > +     ctrl->dev->ops->release_ctrl(ctrl);
> > +
> > +     mutex_lock(&nvme_tcp_ofld_ctrl_mutex);
> > +     list_del(&ctrl->list);
> > +     mutex_unlock(&nvme_tcp_ofld_ctrl_mutex);
> > +
> > +     nvmf_free_options(nctrl->opts);
> > +free_ctrl:
> > +     module_put(dev->ops->module);
> > +     kfree(ctrl->queues);
> > +     kfree(ctrl);
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_teardown_admin_queue(struct nvme_ctrl *ctrl, bool remove=
)
> > +{
> > +     /* Placeholder - teardown_admin_queue */
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_teardown_io_queues(struct nvme_ctrl *nctrl, bool remove)
> > +{
> > +     /* Placeholder - teardown_io_queues */
> > +}
> > +
> > +static void
> > +nvme_tcp_ofld_teardown_ctrl(struct nvme_ctrl *nctrl, bool shutdown)
> > +{
> > +     /* Placeholder - err_work and connect_work */
> > +     nvme_tcp_ofld_teardown_io_queues(nctrl, shutdown);
> > +     blk_mq_quiesce_queue(nctrl->admin_q);
> > +     if (shutdown)
> > +             nvme_shutdown_ctrl(nctrl);
> > +     else
> > +             nvme_disable_ctrl(nctrl);
> > +     nvme_tcp_ofld_teardown_admin_queue(nctrl, shutdown);
> > +}
> > +
> > +static void nvme_tcp_ofld_delete_ctrl(struct nvme_ctrl *nctrl)
> > +{
> > +     nvme_tcp_ofld_teardown_ctrl(nctrl, true);
> > +}
> > +
> > +static int
> > +nvme_tcp_ofld_init_request(struct blk_mq_tag_set *set,
> > +                        struct request *rq,
> > +                        unsigned int hctx_idx,
> > +                        unsigned int numa_node)
> > +{
> > +     struct nvme_tcp_ofld_req *req =3D blk_mq_rq_to_pdu(rq);
> > +
> > +     /* Placeholder - init request */
> > +
> > +     req->done =3D nvme_tcp_ofld_req_done;
> > +
> > +     return 0;
> > +}
> > +
> > +static blk_status_t
> > +nvme_tcp_ofld_queue_rq(struct blk_mq_hw_ctx *hctx,
> > +                    const struct blk_mq_queue_data *bd)
> > +{
> > +     /* Call nvme_setup_cmd(...) */
> > +
> > +     /* Call ops->send_req(...) */
> > +
> > +     return BLK_STS_OK;
> > +}
> > +
> > +static struct blk_mq_ops nvme_tcp_ofld_mq_ops =3D {
> > +     .queue_rq       =3D nvme_tcp_ofld_queue_rq,
> > +     .init_request   =3D nvme_tcp_ofld_init_request,
> > +     /*
> > +      * All additional ops will be also implemented and registered sim=
ilar to
> > +      * tcp.c
> > +      */
> > +};
> > +
> > +static struct blk_mq_ops nvme_tcp_ofld_admin_mq_ops =3D {
> > +     .queue_rq       =3D nvme_tcp_ofld_queue_rq,
> > +     .init_request   =3D nvme_tcp_ofld_init_request,
> > +     /*
> > +      * All additional ops will be also implemented and registered sim=
ilar to
> > +      * tcp.c
> > +      */
> > +};
> > +
> > +static const struct nvme_ctrl_ops nvme_tcp_ofld_ctrl_ops =3D {
> > +     .name                   =3D "tcp_offload",
> > +     .module                 =3D THIS_MODULE,
> > +     .flags                  =3D NVME_F_FABRICS,
> > +     .reg_read32             =3D nvmf_reg_read32,
> > +     .reg_read64             =3D nvmf_reg_read64,
> > +     .reg_write32            =3D nvmf_reg_write32,
> > +     .free_ctrl              =3D nvme_tcp_ofld_free_ctrl,
> > +     .delete_ctrl            =3D nvme_tcp_ofld_delete_ctrl,
> > +     .get_address            =3D nvmf_get_address,
> > +};
> > +
> > +static bool
> > +nvme_tcp_ofld_existing_controller(struct nvmf_ctrl_options *opts)
> > +{
> > +     struct nvme_tcp_ofld_ctrl *ctrl;
> > +     bool found =3D false;
> > +
> > +     mutex_lock(&nvme_tcp_ofld_ctrl_mutex);
> > +     list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list) {
> > +             found =3D nvmf_ip_options_match(&ctrl->nctrl, opts);
>
> Well; meanwhile we've earned yet another flags (hostiface) which allows
> us to specify a network interface.
>
> Originally intended to bind the network flow to a specific interface,
> but question is how it would apply here.
> Do you even _have_ a network interface?
> (I guess you would for the network side, not necessarily for the offload
> part, though).
> What would be the appropriate action here if the user specifies the
> network interface of the network part?
> Still enable the offload?
> Technically that would against the spirit of that flag; so it would be
> feasible to have that flag controller software vs offload behaviour.
> IE one could envision that _using_ this flag to specify the network
> interface would disable the offload engine.
> Mind you, would be slightly counter-intuitive, as we probably don't have
> a corresponding offload interface which we could select.
> But really not sure what would be the best approach here.
>
> We should, however, figure out what to do with that flag.

The opts->host_iface will be added to the nvme-tcp-offload layer and it wil=
l
be passed (together with opts->traddr and opts->host_traddr) to the vendor
driver claim_dev() in order to control the chosen path.

Regarding qedn, with the Marvell NVMeTCP offload design, the network-device
(qede) and the offload-device (qedn) are paired. All network attributes suc=
h
as MAC, VLAN, SRC IP (if not provided) will be queried from the paired
network device.
Hence we will use the qede network device for both the sw NVMeTCP (qede)
and the offload NVMeTCP (qedn) while we will allow a separate attribute to
control which one should be used - the transport type (-t tcp_offload).

As we explained in the cover letter, an alternative approach, and as
a future enhancement that will not impact this series, nvme-cli can be
enhanced with a new flag that will determine whether "-t tcp" should be
the regular nvme-tcp (which will be the default) or nvme-tcp-offload.

The opts->host_iface will be added not as part of this series.

>
> > +             if (found)
> > +                     break;
> > +     }
> > +     mutex_unlock(&nvme_tcp_ofld_ctrl_mutex);
> > +
> > +     return found;
> > +}
> > +
> >  static struct nvme_ctrl *
> >  nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_option=
s *opts)
> >  {
> > +     struct nvme_tcp_ofld_queue *queue;
> >       struct nvme_tcp_ofld_ctrl *ctrl;
> >       struct nvme_tcp_ofld_dev *dev;
> >       struct nvme_ctrl *nctrl;
> > -     int rc =3D 0;
> > +     int i, rc =3D 0;
> >
> >       ctrl =3D kzalloc(sizeof(*ctrl), GFP_KERNEL);
> >       if (!ctrl)
> >               return ERR_PTR(-ENOMEM);
> >
> > +     INIT_LIST_HEAD(&ctrl->list);
> >       nctrl =3D &ctrl->nctrl;
> > +     nctrl->opts =3D opts;
> > +     nctrl->queue_count =3D opts->nr_io_queues + opts->nr_write_queues=
 +
> > +                          opts->nr_poll_queues + 1;
> > +     nctrl->sqsize =3D opts->queue_size - 1;
> > +     nctrl->kato =3D opts->kato;
> > +     if (!(opts->mask & NVMF_OPT_TRSVCID)) {
> > +             opts->trsvcid =3D
> > +                     kstrdup(__stringify(NVME_TCP_DISC_PORT), GFP_KERN=
EL);
> > +             if (!opts->trsvcid) {
> > +                     rc =3D -ENOMEM;
> > +                     goto out_free_ctrl;
> > +             }
> > +             opts->mask |=3D NVMF_OPT_TRSVCID;
> > +     }
> > +
> > +     rc =3D inet_pton_with_scope(&init_net, AF_UNSPEC, opts->traddr,
> > +                               opts->trsvcid,
> > +                               &ctrl->conn_params.remote_ip_addr);
> > +     if (rc) {
> > +             pr_err("malformed address passed: %s:%s\n",
> > +                    opts->traddr, opts->trsvcid);
> > +             goto out_free_ctrl;
> > +     }
> > +
> > +     if (opts->mask & NVMF_OPT_HOST_TRADDR) {
> > +             rc =3D inet_pton_with_scope(&init_net, AF_UNSPEC,
> > +                                       opts->host_traddr, NULL,
> > +                                       &ctrl->conn_params.local_ip_add=
r);
> > +             if (rc) {
> > +                     pr_err("malformed src address passed: %s\n",
> > +                            opts->host_traddr);
> > +                     goto out_free_ctrl;
> > +             }
> > +     }
> >
>
> -> And here we would need to check for the interface ...

It will be done from nvme_tcp_ofld_lookup_dev() by passing opts->host_iface
(together with opts->traddr and opts->host_traddr) to the vendor driver
claim_dev() in order to control the chosen path.
The opts->host_iface will be added not as part of this series.

>
> > -     /* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received=
 opts */
> > +     if (!opts->duplicate_connect &&
> > +         nvme_tcp_ofld_existing_controller(opts)) {
> > +             rc =3D -EALREADY;
> > +             goto out_free_ctrl;
> > +     }
> >
> >       /* Find device that can reach the dest addr */
> >       dev =3D nvme_tcp_ofld_lookup_dev(ctrl);
> > @@ -151,6 +573,10 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, str=
uct nvmf_ctrl_options *opts)
> >               goto out_free_ctrl;
> >       }
> >
> > +     rc =3D nvme_tcp_ofld_check_dev_opts(opts, dev->ops);
> > +     if (rc)
> > +             goto out_module_put;
> > +
> >       ctrl->dev =3D dev;
> >
> >       if (ctrl->dev->ops->max_hw_sectors)
> > @@ -158,14 +584,51 @@ nvme_tcp_ofld_create_ctrl(struct device *ndev, st=
ruct nvmf_ctrl_options *opts)
> >       if (ctrl->dev->ops->max_segments)
> >               nctrl->max_segments =3D ctrl->dev->ops->max_segments;
> >
> > -     /* Init queues */
> > +     ctrl->queues =3D kcalloc(nctrl->queue_count,
> > +                            sizeof(struct nvme_tcp_ofld_queue),
> > +                            GFP_KERNEL);
> > +     if (!ctrl->queues) {
> > +             rc =3D -ENOMEM;
> > +             goto out_module_put;
> > +     }
> > +
> > +     for (i =3D 0; i < nctrl->queue_count; ++i) {
> > +             queue =3D &ctrl->queues[i];
> > +             queue->ctrl =3D ctrl;
> > +             queue->dev =3D dev;
> > +             queue->report_err =3D nvme_tcp_ofld_report_queue_err;
> > +     }
> > +
> > +     rc =3D nvme_init_ctrl(nctrl, ndev, &nvme_tcp_ofld_ctrl_ops, 0);
> > +     if (rc)
> > +             goto out_free_queues;
> > +
> > +     if (!nvme_change_ctrl_state(nctrl, NVME_CTRL_CONNECTING)) {
> > +             WARN_ON_ONCE(1);
> > +             rc =3D -EINTR;
> > +             goto out_uninit_ctrl;
> > +     }
> >
> > -     /* Call nvme_init_ctrl */
> > +     rc =3D nvme_tcp_ofld_setup_ctrl(nctrl, true);
> > +     if (rc)
> > +             goto out_uninit_ctrl;
> >
> > -     /* Setup ctrl */
> > +     dev_info(nctrl->device, "new ctrl: NQN \"%s\", addr %pISp\n",
> > +              opts->subsysnqn, &ctrl->conn_params.remote_ip_addr);
> > +
> > +     mutex_lock(&nvme_tcp_ofld_ctrl_mutex);
> > +     list_add_tail(&ctrl->list, &nvme_tcp_ofld_ctrl_list);
> > +     mutex_unlock(&nvme_tcp_ofld_ctrl_mutex);
> >
> >       return nctrl;
> >
> > +out_uninit_ctrl:
> > +     nvme_uninit_ctrl(nctrl);
> > +     nvme_put_ctrl(nctrl);
> > +out_free_queues:
> > +     kfree(ctrl->queues);
> > +out_module_put:
> > +     module_put(dev->ops->module);
> >  out_free_ctrl:
> >       kfree(ctrl);
> >
> > @@ -193,7 +656,15 @@ static int __init nvme_tcp_ofld_init_module(void)
> >
> >  static void __exit nvme_tcp_ofld_cleanup_module(void)
> >  {
> > +     struct nvme_tcp_ofld_ctrl *ctrl;
> > +
> >       nvmf_unregister_transport(&nvme_tcp_ofld_transport);
> > +
> > +     mutex_lock(&nvme_tcp_ofld_ctrl_mutex);
> > +     list_for_each_entry(ctrl, &nvme_tcp_ofld_ctrl_list, list)
> > +             nvme_delete_ctrl(&ctrl->nctrl);
> > +     mutex_unlock(&nvme_tcp_ofld_ctrl_mutex);
> > +     flush_workqueue(nvme_delete_wq);
> >  }
> >
> >  module_init(nvme_tcp_ofld_init_module);
> >
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                     Kernel Storage Architect
> hare@suse.de                                   +49 911 74053 688
> SUSE Software Solutions Germany GmbH, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, HRB 36809 (AG N=C3=BCrnberg)
