Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD14884FF
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 18:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbiAHRmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 12:42:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233867AbiAHRmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 12:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641663724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eZVUjQiwMvhimCji0d8/xJbQ9eOHnZHI4ZJAgbXoD1Y=;
        b=ip7JZJlIo42oRzKzJlbA+79AOUkoq0+T41nVtpzXlcUQz5Otql7uvVdfMeo0MekIAcpsDK
        qIGoy6d77GewgS7kNy30WnGrIHlWO7714z/V9Y2WwURxOBhCMdBr23S0njTfFXc3a3B+TE
        7JQDCY1LBgt/rGV41krEFIkeTbbMBKk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-BKkwG4QkNf-cCbap8HO-og-1; Sat, 08 Jan 2022 12:42:03 -0500
X-MC-Unique: BKkwG4QkNf-cCbap8HO-og-1
Received: by mail-wm1-f72.google.com with SMTP id r2-20020a05600c35c200b00345c3b82b22so6757405wmq.0
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 09:42:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eZVUjQiwMvhimCji0d8/xJbQ9eOHnZHI4ZJAgbXoD1Y=;
        b=02EoXxeFjyIVOn41sx9rHXfWq2B1YW4OEIu5E8bEqWv0GpDZQ2uf78QRHMPL83Hp9J
         75K4k/lFWBL6biOIgeFgUTzUhCvM6+jBINxH/BCpuZVN+yVZ+VpUZgvB0ucG7Tpv0bjP
         EPjyRJd0HYZP84kmcCtNhKCDLasdl7AUO20t2sxfhw/ogZ4dE+e/P3VDqCljaaeH1Fws
         sc8EcD7TXmlF+QbBirrBcL/qMmDt+KZ4RhSruoCpo9geLw0/hU1jMTSjAjMsTIv6rhGa
         zMUkHZRcE2HOZhB09Mo7jlIEISOy16NmNRbsB3QXQziMy7HPpx96YEWioHDhCEvSFBB7
         IBNA==
X-Gm-Message-State: AOAM533LxaEC9vLz0aHYLXVV0YixSiA7FcUEOp/anJKZFE37pFz+lpgc
        N4TBslbJ1Z63fy6Lb88JBQS2azPxMeEnqRH7K+S+16KUlgD9kAtCP6amGuPaV3YFBmKBfQv+eNn
        9HY5hwsXRBXyq0fZq
X-Received: by 2002:a5d:428e:: with SMTP id k14mr2220369wrq.524.1641663722051;
        Sat, 08 Jan 2022 09:42:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYKBDXf6+Z/pzYSngoalfQglop4wcw0Ierbv2oLgA5+pKSxRs/CvyEYCqC5ZnaNpSy6KPkkw==
X-Received: by 2002:a5d:428e:: with SMTP id k14mr2220359wrq.524.1641663721855;
        Sat, 08 Jan 2022 09:42:01 -0800 (PST)
Received: from redhat.com ([2a10:800d:b77b:0:4c0a:9a47:da3d:38fd])
        by smtp.gmail.com with ESMTPSA id m5sm1939693wml.48.2022.01.08.09.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 09:42:00 -0800 (PST)
Date:   Sat, 8 Jan 2022 12:41:57 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Eli Cohen <elic@nvidia.com>, kbuild-all@lists.01.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [mst-vhost:vhost 30/44]
 drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast to
 restricted __le16
Message-ID: <20220108123934-mutt-send-email-mst@kernel.org>
References: <202201082258.aKRHnaJX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202201082258.aKRHnaJX-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 08, 2022 at 10:48:34PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost
> head:   008842b2060c14544ff452483ffd2241d145c7b2
> commit: 7620d51af29aa1c5d32150db2ac4b6187ef8af3a [30/44] vdpa/mlx5: Support configuring max data virtqueue
> config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20220108/202201082258.aKRHnaJX-lkp@intel.com/config)
> compiler: powerpc-linux-gcc (GCC) 11.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/commit/?id=7620d51af29aa1c5d32150db2ac4b6187ef8af3a
>         git remote add mst-vhost https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
>         git fetch --no-tags mst-vhost vhost
>         git checkout 7620d51af29aa1c5d32150db2ac4b6187ef8af3a
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash drivers/vdpa/mlx5/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
> >> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast to restricted __le16
> >> drivers/vdpa/mlx5/net/mlx5_vnet.c:1247:23: sparse: sparse: cast from restricted __virtio16
> 
> vim +1247 drivers/vdpa/mlx5/net/mlx5_vnet.c
> 
>   1232	
>   1233	static int create_rqt(struct mlx5_vdpa_net *ndev)
>   1234	{
>   1235		__be32 *list;
>   1236		int max_rqt;
>   1237		void *rqtc;
>   1238		int inlen;
>   1239		void *in;
>   1240		int i, j;
>   1241		int err;
>   1242		int num;
>   1243	
>   1244		if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_MQ)))
>   1245			num = 1;
>   1246		else
> > 1247			num = le16_to_cpu(ndev->config.max_virtqueue_pairs);

What is the correct thing to do here?  mlx5vdpa16_to_cpu?

>   1248	
>   1249		max_rqt = min_t(int, roundup_pow_of_two(num),
>   1250				1 << MLX5_CAP_GEN(ndev->mvdev.mdev, log_max_rqt_size));
>   1251		if (max_rqt < 1)
>   1252			return -EOPNOTSUPP;
>   1253	
>   1254		inlen = MLX5_ST_SZ_BYTES(create_rqt_in) + max_rqt * MLX5_ST_SZ_BYTES(rq_num);
>   1255		in = kzalloc(inlen, GFP_KERNEL);
>   1256		if (!in)
>   1257			return -ENOMEM;
>   1258	
>   1259		MLX5_SET(create_rqt_in, in, uid, ndev->mvdev.res.uid);
>   1260		rqtc = MLX5_ADDR_OF(create_rqt_in, in, rqt_context);
>   1261	
>   1262		MLX5_SET(rqtc, rqtc, list_q_type, MLX5_RQTC_LIST_Q_TYPE_VIRTIO_NET_Q);
>   1263		MLX5_SET(rqtc, rqtc, rqt_max_size, max_rqt);
>   1264		list = MLX5_ADDR_OF(rqtc, rqtc, rq_num[0]);
>   1265		for (i = 0, j = 0; i < max_rqt; i++, j += 2)
>   1266			list[i] = cpu_to_be32(ndev->vqs[j % (2 * num)].virtq_id);
>   1267	
>   1268		MLX5_SET(rqtc, rqtc, rqt_actual_size, max_rqt);
>   1269		err = mlx5_vdpa_create_rqt(&ndev->mvdev, in, inlen, &ndev->res.rqtn);
>   1270		kfree(in);
>   1271		if (err)
>   1272			return err;
>   1273	
>   1274		return 0;
>   1275	}
>   1276	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

