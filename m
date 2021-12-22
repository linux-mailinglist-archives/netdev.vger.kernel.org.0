Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778DB47D8F9
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240679AbhLVVwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:52:39 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:45013 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbhLVVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:52:38 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mgvn9-1mYDJR3DET-00hLKG; Wed, 22 Dec 2021 22:52:36 +0100
Received: by mail-wm1-f50.google.com with SMTP id b73so2503311wmd.0;
        Wed, 22 Dec 2021 13:52:36 -0800 (PST)
X-Gm-Message-State: AOAM532uSfnDxCMvZZ0ZvWgeOx2Hbt+XO3pHjZ2E6jiBn3LtynzMrTwA
        3GCTa8QPqD+ivW7lmNtB81VIxEUZ+eqG8CnCvww=
X-Google-Smtp-Source: ABdhPJwONx7Rpb6kHkRzhNXYi2y5zPn1dKRyaTxTjivyBhtZyVwbnbdTNourWsYruBa/96zO4qoNQ3X7TRsmR9Wpe2Y=
X-Received: by 2002:a7b:c448:: with SMTP id l8mr2105372wmi.173.1640209956314;
 Wed, 22 Dec 2021 13:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20211222191320.17662-1-repk@triplefau.lt>
In-Reply-To: <20211222191320.17662-1-repk@triplefau.lt>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 22 Dec 2021 22:52:20 +0100
X-Gmail-Original-Message-ID: <CAK8P3a18b63GoPKiTey8KpEusyffbN97gxP+NM3fyZnOYXv5zg@mail.gmail.com>
Message-ID: <CAK8P3a18b63GoPKiTey8KpEusyffbN97gxP+NM3fyZnOYXv5zg@mail.gmail.com>
Subject: Re: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
To:     Remi Pommarel <repk@triplefau.lt>
Cc:     Networking <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gNy5o0LSKNVT5gOuqvGaZKZtZrNctALhHRTnRARxNCUvX3+JnAj
 mNwQ6rnlbvXEedpKGyMcwV6ihLZ/S321C+TL1o3g04+Q3IM/WT13Wm5vd/Yhs5G+QLWQg8G
 HzHCF28OM/g8Dq58Dn+vgpRXFF/FS83d+oYAh5/A4//0z39hbbTJ1jM0KrN7Bl8QOy3aZ15
 26mHSaDRLrS1W788aq+hA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:c5MnNNy6WwI=:TzT+BRu8n2iA+OWwCwG7U3
 jT7TtTYGofEKnKSZ7Pzpkzd4iDXARrMDBujjU7knPmanDw3X6PV6FygH6pZ+TBA89rzQIH5KS
 M5D6OZJ1Gudcvk4RhDlfyLncqhgT4kgetqf/nH92Pwp7nI/SibD4WcYL6Kty0X32+1EgHMLGd
 UZL93urwKFf9nL8ATdn18jArRIBJdygAgcwZzrsxPjRbhauKPCANohm29rt8fXvDCfprDZedF
 0xS5mpqnAB16k4tNwMA2ZOFoj006ml70UFiNQx83YA2Xzu2t6VbXZC+1Da18kO0m/B2pruRX/
 5ogMtet7A3pVzwgmaN7Huyhazu905ZN/EZeVbPUBBc3oMERA7LlHFC40o2ebmwaEOEViOR2II
 4tUwjgxOdevL/ZKS0oUkVDRQ2hIlh5iq3G8BGsstGqJ5slum7hXM9lo75KGdhHo1YeTRUO3K8
 uTmHhBrrVk0G2lDirsf/8eHBvDYm49NSH8khFsnRaAefZGaSyhMxKrwuGvrS4hnWmNsHEe8Hq
 kucf20DtZiSHqp0DqXPoRBTN4CFxIUxzATql2GIGrKXTgEFiiNMcLW0O5u41zra6wY5vKUZwm
 LkXq2dbZQKFZKFQRFa/CuGTuCthzwoWKn6cyMd2ZLHRUDd+Z5SGeT/9g7k8Uh/wzmk0YPvg3m
 3MyVNdPZqPuJeKwRz7E85PjB9lNlkLuo8Zuo7hBOGS7h0BvFPaxnXf0rKJx30zbpZ3dA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 8:13 PM Remi Pommarel <repk@triplefau.lt> wrote:
>
> Commit 561d8352818f ("bridge: use ndo_siocdevprivate") changed the
> source and destination arguments of copy_{to,from}_user in bridge's
> old_deviceless() from args[1] to uarg breaking SIOC{G,S}IFBR ioctls.
>
> Commit cbd7ad29a507 ("net: bridge: fix ioctl old_deviceless bridge
> argument") fixed only BRCTL_{ADD,DEL}_BRIDGES commands leaving
> BRCTL_GET_BRIDGES one untouched.
>
> The fixes BRCTL_GET_BRIDGES as well
>
> Fixes: 561d8352818f ("bridge: use ndo_siocdevprivate")
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>

Thanks for fixing the regression,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  net/bridge/br_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
> index db4ab2c2ce18..891cfcf45644 100644
> --- a/net/bridge/br_ioctl.c
> +++ b/net/bridge/br_ioctl.c
> @@ -337,7 +337,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
>
>                 args[2] = get_bridge_ifindices(net, indices, args[2]);
>
> -               ret = copy_to_user(uarg, indices,
> +               ret = copy_to_user((void __user *)args[1], indices,
>                                    array_size(args[2], sizeof(int)))
>                         ? -EFAULT : args[2];

The intention of my broken patch was to make it work for compat mode as I did
in br_dev_siocdevprivate(), as this is now the only bit that remains broken.

This could be done along the lines of the patch below, if you see any value in
it. (not tested, probably not quite right).

       Arnd

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index db4ab2c2ce18..138aa96d73f9 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -102,19 +102,9 @@ static int add_del_if(struct net_bridge *br, int
ifindex, int isadd)
        return ret;
 }

-/*
- * Legacy ioctl's through SIOCDEVPRIVATE
- * This interface is deprecated because it was too difficult
- * to do the translation for 32/64bit ioctl compatibility.
- */
-int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
void __user *data, int cmd)
+static int br_dev_read_uargs(unsigned long *args, void __user *argp,
+                            void __user *data)
 {
-       struct net_bridge *br = netdev_priv(dev);
-       struct net_bridge_port *p = NULL;
-       unsigned long args[4];
-       void __user *argp;
-       int ret = -EOPNOTSUPP;
-
        if (in_compat_syscall()) {
                unsigned int cargs[4];

@@ -126,13 +116,29 @@ int br_dev_siocdevprivate(struct net_device
*dev, struct ifreq *rq, void __user
                args[2] = cargs[2];
                args[3] = cargs[3];

-               argp = compat_ptr(args[1]);
+               *argp = compat_ptr(args[1]);
        } else {
                if (copy_from_user(args, data, sizeof(args)))
                        return -EFAULT;

-               argp = (void __user *)args[1];
+               *argp = (void __user *)args[1];
        }
+}
+
+/*
+ * Legacy ioctl's through SIOCDEVPRIVATE
+ * This interface is deprecated because it was too difficult
+ * to do the translation for 32/64bit ioctl compatibility.
+ */
+int br_dev_siocdevprivate(struct net_device *dev, struct ifreq *rq,
void __user *data, int cmd)
+{
+       struct net_bridge *br = netdev_priv(dev);
+       struct net_bridge_port *p = NULL;
+       unsigned long args[4];
+       void __user *argp;
+       int ret;
+
+       ret = br_dev_read_uargs(args, &argp, data);

        switch (args[0]) {
        case BRCTL_ADD_IF:
@@ -301,6 +307,9 @@ int br_dev_siocdevprivate(struct net_device *dev,
struct ifreq *rq, void __user

        case BRCTL_GET_FDB_ENTRIES:
                return get_fdb_entries(br, argp, args[2], args[3]);
+
+       default:
+               ret = -EOPNOTSUPP;
        }

        if (!ret) {
@@ -315,10 +324,13 @@ int br_dev_siocdevprivate(struct net_device
*dev, struct ifreq *rq, void __user

 static int old_deviceless(struct net *net, void __user *uarg)
 {
-       unsigned long args[3];
+       unsigned long args[4];
+       void __user *argp;
+       int ret;

-       if (copy_from_user(args, uarg, sizeof(args)))
-               return -EFAULT;
+       ret = br_dev_read_uargs(args, &argp, data);
+       if (ret)
+               return ret;

        switch (args[0]) {
        case BRCTL_GET_VERSION:
@@ -337,7 +349,7 @@ static int old_deviceless(struct net *net, void
__user *uarg)

                args[2] = get_bridge_ifindices(net, indices, args[2]);

-               ret = copy_to_user(uarg, indices,
+               ret = copy_to_user(argp, indices,
                                   array_size(args[2], sizeof(int)))
                        ? -EFAULT : args[2];

@@ -353,7 +365,7 @@ static int old_deviceless(struct net *net, void
__user *uarg)
                if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
                        return -EPERM;

-               if (copy_from_user(buf, (void __user *)args[1], IFNAMSIZ))
+               if (copy_from_user(buf, argp, IFNAMSIZ))
                        return -EFAULT;

                buf[IFNAMSIZ-1] = 0;
