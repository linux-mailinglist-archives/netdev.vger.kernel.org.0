Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D62DC0D0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409676AbfJRJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:24:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34803 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfJRJYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:24:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id r22so4174935lfm.1
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 02:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mjmobDJezAaFIf6NO9QPxG4uwUBWE84nHWAaBoCD/Os=;
        b=JDXeAE+xSJuqy9JdpBRRtxno1/7BPOnp2AlVxPU0okPUgaoQORP91FrzWzKWIYTYM/
         G3eDMIL0YamwfWVDJz7pzxS8QKqGKh6x42vysKZOV/+dH6i8J9NCcrrXojG5p5oqaQDE
         TmPA1sWLZChjYn2UwOG/OMavKTi8zL69p8Jukum5YhP0xXQXIPGwa4x8S5x5p33iSX+O
         iVh9R3v9o0LavCHc9hzy3VN28imGB4Gel+il3BxYN9nfQcJ7pK+XdCzdj1OKHS/QwuyZ
         i6ldiRNyXa9poWG0OqHjZfq9MBIEuPeb5lyH+b5yDikxupef5L4CAdKyGThSTQkJIHSE
         XEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mjmobDJezAaFIf6NO9QPxG4uwUBWE84nHWAaBoCD/Os=;
        b=a3Ro28XzT8dXzQt1XzHzvFuyTXYkaPrJTBVPcpDGRGBm3cEpeenNrdxu99+5k5e1FU
         jqPqhF8YHr+QZyU+OqQb+sPyri93GQtARhf4ZKZOVmkcivqlbbMIoSCLJ/GGYwU8KhpV
         mJNTDADPsBcHGOAZ//EGHBsQniuAOFGjAn+YqXNmYalWkzkvtasJ69sG1fuOT7mtgykA
         Wsybg9DKDHIebaPYPcwMtC4slV3xoQrbRvkOkkc/TlFgAFggKHCbf2tq8I3XrQr6CFzh
         UDMJKZQhtg+o+Y9s5IzZ5EnN/diScaG3X/lws5yibSTe8XelcQi6hMVxjHUtcNmh27RB
         cfhg==
X-Gm-Message-State: APjAAAXdhzMU6nMit4krBRgXL9/D1s0US3IvN6Q8m2vRtdyde7bSrzTZ
        z5sPPLwiJHG3wy6MevaYWcxS+A==
X-Google-Smtp-Source: APXvYqwX4Y7RAFppjVGwtyt+xvBAN83kH08/BFGPrqV+2W1m776Wc3nnzzvXNLOqktSi6qkpoJAoOA==
X-Received: by 2002:ac2:4304:: with SMTP id l4mr5567495lfh.130.1571390687838;
        Fri, 18 Oct 2019 02:24:47 -0700 (PDT)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id c18sm2737991ljd.27.2019.10.18.02.24.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Oct 2019 02:24:46 -0700 (PDT)
Date:   Fri, 18 Oct 2019 11:24:45 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, ebiederm@xmission.com,
        brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH v14 1/5] fs/nsfs.c: added ns_match
Message-ID: <20191018092444.4kprifhx4yy56yex@netronome.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-2-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017150032.14359-2-cneirabustos@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 12:00:28PM -0300, Carlos Neira wrote:
> ns_match returns true if the namespace inode and dev_t matches the ones
> provided by the caller.
> 
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  fs/nsfs.c               | 8 ++++++++
>  include/linux/proc_ns.h | 2 ++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index a0431642c6b5..256f6295d33d 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
>  	return ERR_PTR(-EINVAL);
>  }
>  
> +/* Returns true if current namespace matches dev/ino.
> + */

The above could be a single line comment.
Perhaps using kdoc format would be appropriate here.

> +bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
> +{
> +	return ((ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev));

The parentheses on the line above seem unnecessary.

> +}
> +
> +
>  static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
>  {
>  	struct inode *inode = d_inode(dentry);
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index d31cb6215905..1da9f33489f3 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -82,6 +82,8 @@ typedef struct ns_common *ns_get_path_helper_t(void *);
>  extern void *ns_get_path_cb(struct path *path, ns_get_path_helper_t ns_get_cb,
>  			    void *private_data);
>  
> +extern bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
> +
>  extern int ns_get_name(char *buf, size_t size, struct task_struct *task,
>  			const struct proc_ns_operations *ns_ops);
>  extern void nsfs_init(void);
> -- 
> 2.20.1
> 
