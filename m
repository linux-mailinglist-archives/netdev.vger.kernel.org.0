Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B91F6D1964
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjCaIHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjCaIHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:07:33 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1101CE072;
        Fri, 31 Mar 2023 01:07:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Vf1OpCK_1680250045;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vf1OpCK_1680250045)
          by smtp.aliyun-inc.com;
          Fri, 31 Mar 2023 16:07:26 +0800
Message-ID: <1680250036.1570807-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH] vringh: fix typos in the vringh_init_* documentation
Date:   Fri, 31 Mar 2023 16:07:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        virtualization@lists.linux-foundation.org
References: <20230331080208.17002-1-sgarzare@redhat.com>
In-Reply-To: <20230331080208.17002-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 10:02:08 +0200, Stefano Garzarella <sgarzare@redhat.com> wrote:
> Replace `userpace` with `userspace`.
>
> Cc: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks

> ---
>  drivers/vhost/vringh.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index a1e27da54481..694462ba3242 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -636,9 +636,9 @@ static inline int xfer_to_user(const struct vringh *vrh,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> - * @desc: the userpace descriptor pointer.
> - * @avail: the userpace avail pointer.
> - * @used: the userpace used pointer.
> + * @desc: the userspace descriptor pointer.
> + * @avail: the userspace avail pointer.
> + * @used: the userspace used pointer.
>   *
>   * Returns an error if num is invalid: you should check pointers
>   * yourself!
> @@ -911,9 +911,9 @@ static inline int kern_xfer(const struct vringh *vrh, void *dst,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> - * @desc: the userpace descriptor pointer.
> - * @avail: the userpace avail pointer.
> - * @used: the userpace used pointer.
> + * @desc: the userspace descriptor pointer.
> + * @avail: the userspace avail pointer.
> + * @used: the userspace used pointer.
>   *
>   * Returns an error if num is invalid.
>   */
> @@ -1306,9 +1306,9 @@ static inline int putused_iotlb(const struct vringh *vrh,
>   * @features: the feature bits for this ring.
>   * @num: the number of elements.
>   * @weak_barriers: true if we only need memory barriers, not I/O.
> - * @desc: the userpace descriptor pointer.
> - * @avail: the userpace avail pointer.
> - * @used: the userpace used pointer.
> + * @desc: the userspace descriptor pointer.
> + * @avail: the userspace avail pointer.
> + * @used: the userspace used pointer.
>   *
>   * Returns an error if num is invalid.
>   */
> --
> 2.39.2
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
