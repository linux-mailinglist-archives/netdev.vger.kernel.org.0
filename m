Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32052108F82
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKYOD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 09:03:26 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45570 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfKYOD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 09:03:26 -0500
Received: by mail-qt1-f196.google.com with SMTP id 30so17226751qtz.12;
        Mon, 25 Nov 2019 06:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=GONIPq20SONBcCz1EJD54XUzwNyuIJzlWKjnUmIBcuo=;
        b=alFWDlz/8xCzoErURZTKNWooRqtCw0xcT4RjIf42RQb9tgKvg42jHPX5FzRgGtBksq
         47IuqLKWzU5Vo3SbxB7RoHI99Q5sKHRQ3Gsro0jD35gnxJLd6vLXuSzz5NGb8QG6nOJN
         kCIjEw/Lx5t+LErEoaAv4xcJwKc9A0QhxLUanTcxzWdbNW4WaJ9SQZJYDcPVHQ89d+v/
         eWtNl4vgTC3vbSxekh1Vz+5oD7PWo7/gdC/21ppKBMYT6yHRP2E24oTlimVqkongANpy
         4pMX119P49kGgB3g8/fgmWJhyhAHSZDSIBdL5L+seEbQHX8SsVsIMr/YJp2dc7asppds
         bY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=GONIPq20SONBcCz1EJD54XUzwNyuIJzlWKjnUmIBcuo=;
        b=tx9O+34/886g6bZMIEI+I7tWnBa9LOOE31upw+CRA6QNpg+6gWLfA5onivcXt13SfK
         SBbxIWRaPgW+yupLeBJ2+Tpa5Lqv7mmqqAbx8YioYJd6smJlQYD8q8Zpg9VAAuxdFBX6
         CyEwOu+ikI+yWMXOP4J/ucEkGkxVF6p5PgR25gX0phM/g+jAw2nYgXiTLHiLdWcKl9C/
         Mm+kH5Wrgw2etrqZ+Hopfjh5DT2gk5hTbVL2bF7WfkKgTyZRfM44kKOcSnErnbGgy5zr
         NM+sMADtrj3ngaahn0psf+8KBZEXbuyL2svneQJ5OKNhatteJO/l9bAXKsz0tdQAEY0W
         5dbw==
X-Gm-Message-State: APjAAAWecXqQgOGCiXM0igetr1DiTP2j0EM4kRS7FaBwRo+Nzw2AJQV5
        3ALi4iFQX7zUE+9GUvjeWfU=
X-Google-Smtp-Source: APXvYqyDMNVvP3MHchpIb1lqvuFnzj7OBxals/8lBxo/QuQi9MX6O5sOblWIgHOkWoTl9Vwq5Wi93g==
X-Received: by 2002:aed:2041:: with SMTP id 59mr28371684qta.79.1574690604687;
        Mon, 25 Nov 2019 06:03:24 -0800 (PST)
Received: from frodo.byteswizards.com (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.gmail.com with ESMTPSA id x12sm3393806qkf.84.2019.11.25.06.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 06:03:23 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:03:19 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [Review Request] Re: [PATCH v15 1/5] fs/nsfs.c: added ns_match
Message-ID: <20191125140319.GA14154@frodo.byteswizards.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
 <20191022191751.3780-2-cneirabustos@gmail.com>
 <7b7ba580-14f8-d5aa-65d5-0d6042e7a566@fb.com>
 <63882673-849d-cae3-1432-1d9411c10348@fb.com>
 <01acf191-f1aa-bf01-0945-56e4f37af69b@fb.com>
 <4b323ffc-0b04-a00e-0e39-734dee0e2578@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4b323ffc-0b04-a00e-0e39-734dee0e2578@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong,

I think the merge window has closed, should I resubmit these patches, or 
wait for Eric's feedback ?

Bests

On Tue, Nov 12, 2019 at 03:18:20PM +0000, Yonghong Song wrote:
> Eric,
> 
> ping again. Any comment on this patch?
> 
> On 10/31/19 3:31 PM, Yonghong Song wrote:
> > 
> > Eric,
> > 
> > In case that you missed the email, I added "[Review Request]"
> > and pinged again. It would be good if you can take a look
> > and ack if it looks good to you.
> > 
> > Thanks!
> > 
> > 
> > On 10/28/19 8:34 AM, Yonghong Song wrote:
> >> Ping again.
> >>
> >> Eric, could you take a look at this patch and ack it if it is okay?
> >>
> >> Thanks!
> >>
> >>
> >> On 10/22/19 8:05 PM, Yonghong Song wrote:
> >>>
> >>> Hi, Eric,
> >>>
> >>> Could you take a look at this patch the series as well?
> >>> If it looks good, could you ack the patch #1?
> >>>
> >>> Thanks!
> >>>
> >>> On 10/22/19 12:17 PM, Carlos Neira wrote:
> >>>> ns_match returns true if the namespace inode and dev_t matches the ones
> >>>> provided by the caller.
> >>>>
> >>>> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> >>>> ---
> >>>>     fs/nsfs.c               | 14 ++++++++++++++
> >>>>     include/linux/proc_ns.h |  2 ++
> >>>>     2 files changed, 16 insertions(+)
> >>>>
> >>>> diff --git a/fs/nsfs.c b/fs/nsfs.c
> >>>> index a0431642c6b5..ef59cf347285 100644
> >>>> --- a/fs/nsfs.c
> >>>> +++ b/fs/nsfs.c
> >>>> @@ -245,6 +245,20 @@ struct file *proc_ns_fget(int fd)
> >>>>         return ERR_PTR(-EINVAL);
> >>>>     }
> >>>> +/**
> >>>> + * ns_match() - Returns true if current namespace matches dev/ino 
> >>>> provided.
> >>>> + * @ns_common: current ns
> >>>> + * @dev: dev_t from nsfs that will be matched against current nsfs
> >>>> + * @ino: ino_t from nsfs that will be matched against current nsfs
> >>>> + *
> >>>> + * Return: true if dev and ino matches the current nsfs.
> >>>> + */
> >>>> +bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
> >>>> +{
> >>>> +    return (ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev);
> >>>> +}
> >>>> +
> >>>> +
> >>>>     static int nsfs_show_path(struct seq_file *seq, struct dentry 
> >>>> *dentry)
> >>>>     {
> >>>>         struct inode *inode = d_inode(dentry);
> >>>> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> >>>> index d31cb6215905..1da9f33489f3 100644
> >>>> --- a/include/linux/proc_ns.h
> >>>> +++ b/include/linux/proc_ns.h
> >>>> @@ -82,6 +82,8 @@ typedef struct ns_common 
> >>>> *ns_get_path_helper_t(void *);
> >>>>     extern void *ns_get_path_cb(struct path *path, 
> >>>> ns_get_path_helper_t ns_get_cb,
> >>>>                     void *private_data);
> >>>> +extern bool ns_match(const struct ns_common *ns, dev_t dev, ino_t 
> >>>> ino);
> >>>> +
> >>>>     extern int ns_get_name(char *buf, size_t size, struct 
> >>>> task_struct *task,
> >>>>                 const struct proc_ns_operations *ns_ops);
> >>>>     extern void nsfs_init(void);
> >>>>
