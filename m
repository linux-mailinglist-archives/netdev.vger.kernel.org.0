Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77012D47F9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 18:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgLIRaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 12:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbgLIRaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 12:30:14 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEB6C0613D6;
        Wed,  9 Dec 2020 09:29:33 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id c1so2622424wrq.6;
        Wed, 09 Dec 2020 09:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ktNcZlpHUvdxLX3cjuKCxCtuoBZO863saLbiYCA6rxM=;
        b=ksEpEc8eGz+GmHxg7jwJsCz3KTo3Kw7aw67zItf0qqVAKrsU/sS1tKIH/9nMKv+kcg
         Zkp16waWwwWXKbCYOo7P8iiEPFUytugG2jZARIs8njNdK23d4YHEZ7LjfC7T0PopiCyP
         JzKkSiPSeXXuru1XdO36b0o0wN7MWgkW/w83UoZ0092SYHbH9j9jnGHx6s5AVvQlpVkK
         SIpT+h7o7BLU2ZO4KzWxjygYq6Ybwk2hPXUOpRxefCghTIdjs7+7I4P11kOYZngrcWFV
         BABm3q/HtytNI0yWUgLzs20dS94VQxHEiTLLypgho2Jd6a0CiscFX9Kxky2Aix6zDIPf
         SpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ktNcZlpHUvdxLX3cjuKCxCtuoBZO863saLbiYCA6rxM=;
        b=nc8wO4x0ZjzgEC/2AN4hyt3HaUt0gUxmXk2/l3I1bKHU5g/b5c+skGxjLsac8B4w98
         JDdqbRFH5/i/BUnblDxRugeFsHoYqopP56FzIQVlNYOhJP3lrQe4lhLy6Uw8fnUjzHZu
         8bJe1O7Rm+M6wrBnhq0sha0Q9F4bKH84yj88hNickhPyN9aAQodtoVkfrv3PGKejXclp
         63n5mVXgGTjBCrLKriI1kTY2JhTAuZVpSoM5cI6hWFk30kQNJdct6A7B9NPjsjBQvzF/
         jlJJ0eMJ9SA2PaJid7qDnjquXZqmyDaVd0nvwwOsh3UIay2p1wkZjqRmKVuvmRVptSEI
         Gj9Q==
X-Gm-Message-State: AOAM533loL0stdHlflUny17I5vDOhTHMVurgoJ1xq53/J3G0ayiJAeyC
        bsOxyGbxpJaAffPoOZlmwS0=
X-Google-Smtp-Source: ABdhPJxiri35v13cS5IdRJP5OZfe8AdB1lWgbBt/7pCVYE2Mdi40uxERD7xKJ3wD3sJBcktaJPcAAA==
X-Received: by 2002:a05:6000:11c1:: with SMTP id i1mr3924042wrx.16.1607534972010;
        Wed, 09 Dec 2020 09:29:32 -0800 (PST)
Received: from [10.11.11.4] ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id u6sm5542693wrm.90.2020.12.09.09.29.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 09:29:30 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.31\))
Subject: Re: Urgent: BUG: PPP ioctl Transport endpoint is not connected
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
Date:   Wed, 9 Dec 2020 19:29:28 +0200
Cc:     "linux-kernel@vger kernel. org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D9B7DF1-3F32-4277-BFC7-CDD155B6869B@gmail.com>
References: <83C781EB-5D66-426E-A216-E1B846A3EC8A@gmail.com>
 <20201209164013.GA21199@linux.home>
 <1E49F9F8-0325-439E-B200-17C8CB6A3CBE@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
X-Mailer: Apple Mail (2.3654.40.0.2.31)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I make diff linux 4.14.211 and 4.15 kernel

And changes is:

atomic_inc to refcount_inc=20

And on other part of code in ppp_generic.c remove skb_free =E2=80=A6.



You see diff down :=20


--- linux-4.14.211/drivers/net/ppp/ppp_generic.c	2020-12-08 =
09:17:35.000000000 +0000
+++ linux-4.15/drivers/net/ppp/ppp_generic.c	2018-01-28 =
21:20:33.000000000 +0000
@@ -51,6 +51,7 @@
 #include <asm/unaligned.h>
 #include <net/slhc_vj.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>

 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
@@ -84,7 +85,7 @@ struct ppp_file {
 	struct sk_buff_head xq;		/* pppd transmit queue */
 	struct sk_buff_head rq;		/* receive queue for pppd */
 	wait_queue_head_t rwait;	/* for poll on reading /dev/ppp =
*/
-	atomic_t	refcnt;		/* # refs (incl /dev/ppp =
attached) */
+	refcount_t	refcnt;		/* # refs (incl /dev/ppp =
attached) */
 	int		hdrlen;		/* space to leave for headers */
 	int		index;		/* interface unit / channel =
number */
 	int		dead;		/* unit/channel has been shut =
down */
@@ -256,7 +257,7 @@ struct ppp_net {
 /* Prototypes. */
 static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 			struct file *file, unsigned int cmd, unsigned =
long arg);
-static void ppp_xmit_process(struct ppp *ppp, struct sk_buff *skb);
+static void ppp_xmit_process(struct ppp *ppp);
 static void ppp_send_frame(struct ppp *ppp, struct sk_buff *skb);
 static void ppp_push(struct ppp *ppp);
 static void ppp_channel_push(struct channel *pch);
@@ -389,7 +390,7 @@ static int ppp_open(struct inode *inode,
 	/*
 	 * This could (should?) be enforced by the permissions on =
/dev/ppp.
 	 */
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(file->f_cred->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 	return 0;
 }
@@ -408,7 +409,7 @@ static int ppp_release(struct inode *unu
 				unregister_netdevice(ppp->dev);
 			rtnl_unlock();
 		}
-		if (atomic_dec_and_test(&pf->refcnt)) {
+		if (refcount_dec_and_test(&pf->refcnt)) {
 			switch (pf->kind) {
 			case INTERFACE:
 				ppp_destroy_interface(PF_TO_PPP(pf));
@@ -512,12 +513,13 @@ static ssize_t ppp_write(struct file *fi
 		goto out;
 	}

+	skb_queue_tail(&pf->xq, skb);
+
 	switch (pf->kind) {
 	case INTERFACE:
-		ppp_xmit_process(PF_TO_PPP(pf), skb);
+		ppp_xmit_process(PF_TO_PPP(pf));
 		break;
 	case CHANNEL:
-		skb_queue_tail(&pf->xq, skb);
 		ppp_channel_push(PF_TO_CHANNEL(pf));
 		break;
 	}
@@ -880,7 +882,7 @@ static int ppp_unattached_ioctl(struct n
 		mutex_lock(&pn->all_ppp_mutex);
 		ppp =3D ppp_find_unit(pn, unit);
 		if (ppp) {
-			atomic_inc(&ppp->file.refcnt);
+			refcount_inc(&ppp->file.refcnt);
 			file->private_data =3D &ppp->file;
 			err =3D 0;
 		}
@@ -895,7 +897,7 @@ static int ppp_unattached_ioctl(struct n
 		spin_lock_bh(&pn->all_channels_lock);
 		chan =3D ppp_find_channel(pn, unit);
 		if (chan) {
-			atomic_inc(&chan->file.refcnt);
+			refcount_inc(&chan->file.refcnt);
 			file->private_data =3D &chan->file;
 			err =3D 0;
 		}
@@ -960,6 +962,8 @@ static __net_exit void ppp_exit_net(stru

 	mutex_destroy(&pn->all_ppp_mutex);
 	idr_destroy(&pn->units_idr);
+	WARN_ON_ONCE(!list_empty(&pn->all_channels));
+	WARN_ON_ONCE(!list_empty(&pn->new_channels));
 }

 static struct pernet_operations ppp_net_ops =3D {
@@ -1263,8 +1267,8 @@ ppp_start_xmit(struct sk_buff *skb, stru
 	put_unaligned_be16(proto, pp);

 	skb_scrub_packet(skb, !net_eq(ppp->ppp_net, dev_net(dev)));
-	ppp_xmit_process(ppp, skb);
-
+	skb_queue_tail(&ppp->file.xq, skb);
+	ppp_xmit_process(ppp);
 	return NETDEV_TX_OK;

  outf:
@@ -1349,7 +1353,7 @@ static int ppp_dev_init(struct net_devic
 	 * that ppp_destroy_interface() won't run before the device gets
 	 * unregistered.
 	 */
-	atomic_inc(&ppp->file.refcnt);
+	refcount_inc(&ppp->file.refcnt);

 	return 0;
 }
@@ -1378,7 +1382,7 @@ static void ppp_dev_priv_destructor(stru
 	struct ppp *ppp;

 	ppp =3D netdev_priv(dev);
-	if (atomic_dec_and_test(&ppp->file.refcnt))
+	if (refcount_dec_and_test(&ppp->file.refcnt))
 		ppp_destroy_interface(ppp);
 }

@@ -1416,14 +1420,13 @@ static void ppp_setup(struct net_device
  */

 /* Called to do any work queued up on the transmit side that can now be =
done */
-static void __ppp_xmit_process(struct ppp *ppp, struct sk_buff *skb)
+static void __ppp_xmit_process(struct ppp *ppp)
 {
+	struct sk_buff *skb;
+
 	ppp_xmit_lock(ppp);
 	if (!ppp->closing) {
 		ppp_push(ppp);
-
-		if (skb)
-			skb_queue_tail(&ppp->file.xq, skb);
 		while (!ppp->xmit_pending &&
 		       (skb =3D skb_dequeue(&ppp->file.xq)))
 			ppp_send_frame(ppp, skb);
@@ -1433,13 +1436,11 @@ static void __ppp_xmit_process(struct pp
 			netif_wake_queue(ppp->dev);
 		else
 			netif_stop_queue(ppp->dev);
-	} else {
-		kfree_skb(skb);
 	}
 	ppp_xmit_unlock(ppp);
 }

-static void ppp_xmit_process(struct ppp *ppp, struct sk_buff *skb)
+static void ppp_xmit_process(struct ppp *ppp)
 {
 	local_bh_disable();

@@ -1447,7 +1448,7 @@ static void ppp_xmit_process(struct ppp
 		goto err;

 	(*this_cpu_ptr(ppp->xmit_recursion))++;
-	__ppp_xmit_process(ppp, skb);
+	__ppp_xmit_process(ppp);
 	(*this_cpu_ptr(ppp->xmit_recursion))--;

 	local_bh_enable();
@@ -1457,8 +1458,6 @@ static void ppp_xmit_process(struct ppp
 err:
 	local_bh_enable();

-	kfree_skb(skb);
-
 	if (net_ratelimit())
 		netdev_err(ppp->dev, "recursion detected\n");
 }
@@ -1943,7 +1942,7 @@ static void __ppp_channel_push(struct ch
 	if (skb_queue_empty(&pch->file.xq)) {
 		ppp =3D pch->ppp;
 		if (ppp)
-			__ppp_xmit_process(ppp, NULL);
+			__ppp_xmit_process(ppp);
 	}
 }

@@ -2682,7 +2681,7 @@ ppp_unregister_channel(struct ppp_channe

 	pch->file.dead =3D 1;
 	wake_up_interruptible(&pch->file.rwait);
-	if (atomic_dec_and_test(&pch->file.refcnt))
+	if (refcount_dec_and_test(&pch->file.refcnt))
 		ppp_destroy_channel(pch);
 }

@@ -3052,7 +3051,7 @@ init_ppp_file(struct ppp_file *pf, int k
 	pf->kind =3D kind;
 	skb_queue_head_init(&pf->xq);
 	skb_queue_head_init(&pf->rq);
-	atomic_set(&pf->refcnt, 1);
+	refcount_set(&pf->refcnt, 1);
 	init_waitqueue_head(&pf->rwait);
 }

@@ -3162,15 +3161,6 @@ ppp_connect_channel(struct channel *pch,
 		goto outl;

 	ppp_lock(ppp);
-	spin_lock_bh(&pch->downl);
-	if (!pch->chan) {
-		/* Don't connect unregistered channels */
-		spin_unlock_bh(&pch->downl);
-		ppp_unlock(ppp);
-		ret =3D -ENOTCONN;
-		goto outl;
-	}
-	spin_unlock_bh(&pch->downl);
 	if (pch->file.hdrlen > ppp->file.hdrlen)
 		ppp->file.hdrlen =3D pch->file.hdrlen;
 	hdrlen =3D pch->file.hdrlen + 2;	/* for protocol bytes */
@@ -3179,7 +3169,7 @@ ppp_connect_channel(struct channel *pch,
 	list_add_tail(&pch->clist, &ppp->channels);
 	++ppp->n_channels;
 	pch->ppp =3D ppp;
-	atomic_inc(&ppp->file.refcnt);
+	refcount_inc(&ppp->file.refcnt);
 	ppp_unlock(ppp);
 	ret =3D 0;

@@ -3210,7 +3200,7 @@ ppp_disconnect_channel(struct channel *p
 		if (--ppp->n_channels =3D=3D 0)
 			wake_up_interruptible(&ppp->file.rwait);
 		ppp_unlock(ppp);
-		if (atomic_dec_and_test(&ppp->file.refcnt))
+		if (refcount_dec_and_test(&ppp->file.refcnt))
 			ppp_destroy_interface(ppp);
 		err =3D 0;
 	}

> On 9 Dec 2020, at 18:57, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Nault=20
>=20
>=20
>=20
>> On 9 Dec 2020, at 18:40, Guillaume Nault <gnault@redhat.com> wrote:
>>=20
>> On Wed, Dec 09, 2020 at 04:47:52PM +0200, Martin Zaharinov wrote:
>>> Hi All
>>>=20
>>> I have problem with latest kernel release=20
>>> And the problem is base on this late problem :
>>>=20
>>>=20
>>> =
https://www.mail-archive.com/search?l=3Dnetdev@vger.kernel.org&q=3Dsubject=
:%22Re%5C%3A+ppp%5C%2Fpppoe%2C+still+panic+4.15.3+in+ppp_push%22&o=3Dnewes=
t&f=3D1
>>>=20
>>> I have same problem in kernel 5.6 > now I use kernel 5.9.13 and have =
same problem.
>>>=20
>>>=20
>>> In kernel 5.9.13 now don=E2=80=99t have any crashes in dimes but in =
one moment accel service stop with defunct and in log have many of this =
line :
>>>=20
>>>=20
>>> error: vlan608: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>> error: vlan617: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>> error: vlan679: ioctl(PPPIOCCONNECT): Transport endpoint is not =
connected
>>>=20
>>> In one moment connected user bump double or triple and after that =
service defunct and need wait to drop all session to start .
>>>=20
>>> I talk with accel-ppp team and they said this is kernel related =
problem and to back to kernel 4.14 there is not this problem.
>>>=20
>>> Problem is come after kernel 4.15 > and not have solution to this =
moment.
>>=20
>> I'm sorry, I don't understand.
>> Do you mean that v4.14 worked fine (no crash, no ioctl() error)?
>> Did the problem start appearing in v4.15? Or did v4.15 work and the
>> problem appeared in v4.16?
>=20
> In Telegram group I talk with Sergey and Dimka and told my the problem =
is come after changes from 4.14 to 4.15=20
> Sergey write this : "as I know, there was a similar issue in kernel =
4.15 so maybe it is still not fixed=E2=80=9D
>=20
> I don=E2=80=99t have options to test with this old kernel 4.14.xxx i =
don=E2=80=99t have support for them.
>=20
>=20
>>=20
>>> Please help to find the problem.
>>>=20
>>> Last time in link I see is make changes in ppp_generic.c=20
>>>=20
>>> ppp_lock(ppp);
>>>       spin_lock_bh(&pch->downl);
>>>       if (!pch->chan) {
>>>               /* Don't connect unregistered channels */
>>>               spin_unlock_bh(&pch->downl);
>>>               ppp_unlock(ppp);
>>>               ret =3D -ENOTCONN;
>>>               goto outl;
>>>       }
>>>       spin_unlock_bh(&pch->downl);
>>>=20
>>>=20
>>> But this fix only to don=E2=80=99t display error and freeze system=20=

>>> The problem is stay and is to big.
>>=20
>> Do you use accel-ppp's unit-cache option? Does the problem go away if
>> you stop using it?
>>=20
>=20
> No I don=E2=80=99t use unit-cache , if I set unit-cache accel-ppp =
defunct same but user Is connect and disconnet more fast.
>=20
> The problem is same with unit and without .=20
> Only after this patch I don=E2=80=99t see error in dimes but this is =
not solution.
> In network have customer what have power cut problem, when drop 600 =
user and back Is normal but in this moment kernel is locking and start =
to make this :=20
> sessions:
>  starting: 4235
>  active: 3882
>  finishing: 378
>=20
> The problem is starting session is not real user normal user in this =
server is ~4k customers .
>=20
> I use pppd_compat .
>=20
> Any idea ?
>=20
>>>=20
>>> Please help to fix.
> Martin

