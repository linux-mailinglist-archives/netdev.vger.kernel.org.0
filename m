Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A77556817
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFZL5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:57:49 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:45472 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZL5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:57:49 -0400
Received: by mail-yw1-f46.google.com with SMTP id m16so1007647ywh.12;
        Wed, 26 Jun 2019 04:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4ZZejluyzygAGId9P70SnPk46k+fKDk14NOgv7nz2Q=;
        b=er7wKWWN7SwiOoGFOcvIs/2jmvTyklPDAGNgp1EFgjYv09ZD4NHb7f8m/1FdnZex1g
         9r4BSGLPtaviuOjq2OFOifwabVYKBSnUcFg09tl9QMjNsN+NO7PBhZAgaZCKKp/CI9a6
         Dzt2KfGZw6aRmxFfE8BoStRZnQW43Wlia/MNcaBZSG/4wsyCpOhUD93a/Mtb/qVUtK7K
         taX9Kx4pcbSYdxBiwv08oUv1j/J5ZZaO2pWeEm0AdP/70yYZqDAg0QxYBvM8KE0SX+Uh
         cE3c8zI0uS46tG3G0ThU7YEM5eUnYtUnkV+wlYy7R/cAo/p2QEB1cXr0QmfUCz9eiVw4
         ZZjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4ZZejluyzygAGId9P70SnPk46k+fKDk14NOgv7nz2Q=;
        b=nSiZ5T2mNTNPTh0w1DhhZpwdkQiGx3JLRS767VhgBJfpqFtWg0FMA24u2Xew6Rp/5n
         ViN0/fKWVhFCrVrGRzEHqaNIHjsqDvqIrK/Yw2W/5nAIKir7rQYFlDA9EDkEwsf23DNY
         v5hY2Bg4J/qZBPhll6iXJAFApVt1a5Kaw/uoRbpQKqab7u0kKN4WckZdgfyiun61DzQE
         e1j21VzoZ3kiYuDwBLZlUGFKWoEQVhjhy/oIGA8so7jVWrZNZ4GH3ebRRWYOI9lvAG3U
         o4YCR0THGpw8qNpCoJ3/oELURRP7V200OBQmPJ7W/G1WMfczQEuKFd6p+4tRWQk9s1e2
         SncA==
X-Gm-Message-State: APjAAAU7Xn/FbB9PRcAYhqGoxG/zCmYUqzinxPpqt5l/9yid0oRtEvyI
        NMB6+/XZ2sk5SZfPGLDXseWGmTJ8InKgysE04k4=
X-Google-Smtp-Source: APXvYqzng0P8vanegK8f7xZtEZg8E7xwKrhp3ZE3AgQR3g1O9rp0jLr4QIproal9uYSmzC7yNXQpJqro8YdtdVkdoF0=
X-Received: by 2002:a0d:eec3:: with SMTP id x186mr2541675ywe.510.1561550268021;
 Wed, 26 Jun 2019 04:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190625205701.17849-1-saeedm@mellanox.com> <20190625205701.17849-9-saeedm@mellanox.com>
 <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
In-Reply-To: <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 26 Jun 2019 14:57:36 +0300
Message-ID: <CAJ3xEMhrZgUkekCh+-bUFataSAWZA_xx9sCCzRfkjnE0Lz7M2w@mail.gmail.com>
Subject: Re: [for-next V2 08/10] linux/dim: Implement rdma_dim
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Idan Burstein <idanb@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 1:03 AM Sagi Grimberg <sagi@grimberg.me> wrote:
>
> > +void rdma_dim(struct dim *dim, u64 completions)
> > +{
> > +     struct dim_sample *curr_sample = &dim->measuring_sample;
> > +     struct dim_stats curr_stats;
> > +     u32 nevents;
> > +
> > +     dim_update_sample_with_comps(curr_sample->event_ctr + 1,
> > +                                  curr_sample->pkt_ctr,
> > +                                  curr_sample->byte_ctr,
> > +                                  curr_sample->comp_ctr + completions,
> > +                                  &dim->measuring_sample);
>
> If this is the only caller, why add pkt_ctr and byte_ctr at all?

Hi Sagi,

Thanks for the fast review and feedback, other than the default per
ib/rdma device setup for rdma
dim / adaptive-moderation for which Idan commented on (and lets
discuss it there please) seems
the rest of the comments are fine and Yamin will respond / address
them in the coming days.

Or.
