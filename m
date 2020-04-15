Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6F71A9104
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 04:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392998AbgDOClB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 22:41:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392992AbgDOCkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 22:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586918448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzXqQupdcEVzrxLeJPdjg5a4wdvji8UTh98rlK08KT4=;
        b=ID39x2aGtYnC0dko/GYG99CK+9Eckb61pJUvlT0l6JSvocFgIWNqDFhYPOZkOpR3xl1dd9
        HPh+Fc2lqf74Lo7VY+bgkNr614fGsZtYijhk+bsOGE3j22olfPftVA+Y6TFHIPAGwENtZZ
        OSR5NEcXcsq8C7/wrbvAaPuxthXhCNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-hDb6UCXEMeyJufD6v45JYg-1; Tue, 14 Apr 2020 22:40:17 -0400
X-MC-Unique: hDb6UCXEMeyJufD6v45JYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6618A107ACC7;
        Wed, 15 Apr 2020 02:40:15 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4653A5C1B0;
        Wed, 15 Apr 2020 02:40:04 +0000 (UTC)
Subject: Re: [PATCH] vhost: do not enable VHOST_MENU by default
To:     kbuild test robot <lkp@intel.com>, mst@redhat.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     kbuild-all@lists.01.org
References: <20200414024438.19103-1-jasowang@redhat.com>
 <202004150530.wxnpDMSc%lkp@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9561fec3-1a50-3a87-4012-e9761e677708@redhat.com>
Date:   Wed, 15 Apr 2020 10:40:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <202004150530.wxnpDMSc%lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/15 =E4=B8=8A=E5=8D=885:15, kbuild test robot wrote:
> Hi Jason,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on vhost/linux-next]
> [also build test ERROR on next-20200414]
> [cannot apply to powerpc/next s390/features v5.7-rc1]
> [if your patch is applied to the wrong git tree, please drop us a note =
to help
> improve the system. BTW, we also suggest to use '--base' option to spec=
ify the
> base tree in git format-patch, please see https://stackoverflow.com/a/3=
7406982]
>
> url:    https://github.com/0day-ci/linux/commits/Jason-Wang/vhost-do-no=
t-enable-VHOST_MENU-by-default/20200414-110807
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git l=
inux-next
> config: ia64-randconfig-a001-20200415 (attached as .config)
> compiler: ia64-linux-gcc (GCC) 9.3.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/=
sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          GCC_VERSION=3D9.3.0 make.cross ARCH=3Dia64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
>     drivers/vhost/vhost.c: In function 'vhost_vring_ioctl':
>>> drivers/vhost/vhost.c:1577:33: error: implicit declaration of functio=
n 'eventfd_fget'; did you mean 'eventfd_signal'? [-Werror=3Dimplicit-func=
tion-declaration]
>      1577 |   eventfp =3D f.fd =3D=3D -1 ? NULL : eventfd_fget(f.fd);
>           |                                 ^~~~~~~~~~~~
>           |                                 eventfd_signal
>>> drivers/vhost/vhost.c:1577:31: warning: pointer/integer type mismatch=
 in conditional expression


Forget to make VHOST depend on EVENTFD.

Will send v2.

Thanks


>      1577 |   eventfp =3D f.fd =3D=3D -1 ? NULL : eventfd_fget(f.fd);
>           |                               ^
>     cc1: some warnings being treated as errors
>
> vim +1577 drivers/vhost/vhost.c
>
> feebcaeac79ad8 Jason Wang         2019-05-24  1493
> feebcaeac79ad8 Jason Wang         2019-05-24  1494  static long vhost_v=
ring_set_num_addr(struct vhost_dev *d,
> feebcaeac79ad8 Jason Wang         2019-05-24  1495  				     struct vho=
st_virtqueue *vq,
> feebcaeac79ad8 Jason Wang         2019-05-24  1496  				     unsigned i=
nt ioctl,
> feebcaeac79ad8 Jason Wang         2019-05-24  1497  				     void __use=
r *argp)
> feebcaeac79ad8 Jason Wang         2019-05-24  1498  {
> feebcaeac79ad8 Jason Wang         2019-05-24  1499  	long r;
> feebcaeac79ad8 Jason Wang         2019-05-24  1500
> feebcaeac79ad8 Jason Wang         2019-05-24  1501  	mutex_lock(&vq->mu=
tex);
> feebcaeac79ad8 Jason Wang         2019-05-24  1502
> feebcaeac79ad8 Jason Wang         2019-05-24  1503  	switch (ioctl) {
> feebcaeac79ad8 Jason Wang         2019-05-24  1504  	case VHOST_SET_VRI=
NG_NUM:
> feebcaeac79ad8 Jason Wang         2019-05-24  1505  		r =3D vhost_vring=
_set_num(d, vq, argp);
> feebcaeac79ad8 Jason Wang         2019-05-24  1506  		break;
> feebcaeac79ad8 Jason Wang         2019-05-24  1507  	case VHOST_SET_VRI=
NG_ADDR:
> feebcaeac79ad8 Jason Wang         2019-05-24  1508  		r =3D vhost_vring=
_set_addr(d, vq, argp);
> feebcaeac79ad8 Jason Wang         2019-05-24  1509  		break;
> feebcaeac79ad8 Jason Wang         2019-05-24  1510  	default:
> feebcaeac79ad8 Jason Wang         2019-05-24  1511  		BUG();
> feebcaeac79ad8 Jason Wang         2019-05-24  1512  	}
> feebcaeac79ad8 Jason Wang         2019-05-24  1513
> feebcaeac79ad8 Jason Wang         2019-05-24  1514  	mutex_unlock(&vq->=
mutex);
> feebcaeac79ad8 Jason Wang         2019-05-24  1515
> feebcaeac79ad8 Jason Wang         2019-05-24  1516  	return r;
> feebcaeac79ad8 Jason Wang         2019-05-24  1517  }
> 26b36604523f4a Sonny Rao          2018-03-14  1518  long vhost_vring_io=
ctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1519  {
> cecb46f194460d Al Viro            2012-08-27  1520  	struct file *event=
fp, *filep =3D NULL;
> cecb46f194460d Al Viro            2012-08-27  1521  	bool pollstart =3D=
 false, pollstop =3D false;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1522  	struct eventfd_ctx=
 *ctx =3D NULL;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1523  	u32 __user *idxp =3D=
 argp;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1524  	struct vhost_virtq=
ueue *vq;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1525  	struct vhost_vring=
_state s;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1526  	struct vhost_vring=
_file f;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1527  	u32 idx;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1528  	long r;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1529
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1530  	r =3D get_user(idx=
, idxp);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1531  	if (r < 0)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1532  		return r;
> 0f3d9a17469d71 Krishna Kumar      2010-05-25  1533  	if (idx >=3D d->nv=
qs)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1534  		return -ENOBUFS;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1535
> ff002269a4ee9c Jason Wang         2018-10-30  1536  	idx =3D array_inde=
x_nospec(idx, d->nvqs);
> 3ab2e420ec1caf Asias He           2013-04-27  1537  	vq =3D d->vqs[idx]=
;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1538
> feebcaeac79ad8 Jason Wang         2019-05-24  1539  	if (ioctl =3D=3D V=
HOST_SET_VRING_NUM ||
> feebcaeac79ad8 Jason Wang         2019-05-24  1540  	    ioctl =3D=3D V=
HOST_SET_VRING_ADDR) {
> feebcaeac79ad8 Jason Wang         2019-05-24  1541  		return vhost_vrin=
g_set_num_addr(d, vq, ioctl, argp);
> feebcaeac79ad8 Jason Wang         2019-05-24  1542  	}
> feebcaeac79ad8 Jason Wang         2019-05-24  1543
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1544  	mutex_lock(&vq->mu=
tex);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1545
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1546  	switch (ioctl) {
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1547  	case VHOST_SET_VRI=
NG_BASE:
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1548  		/* Moving base wi=
th an active backend?
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1549  		 * You don't want=
 to do that. */
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1550  		if (vq->private_d=
ata) {
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1551  			r =3D -EBUSY;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1552  			break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1553  		}
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1554  		if (copy_from_use=
r(&s, argp, sizeof s)) {
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1555  			r =3D -EFAULT;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1556  			break;
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1557  		}
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1558  		if (s.num > 0xfff=
f) {
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1559  			r =3D -EINVAL;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1560  			break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1561  		}
> 8d65843c44269c Jason Wang         2017-07-27  1562  		vq->last_avail_id=
x =3D s.num;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1563  		/* Forget the cac=
hed index value. */
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1564  		vq->avail_idx =3D=
 vq->last_avail_idx;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1565  		break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1566  	case VHOST_GET_VRI=
NG_BASE:
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1567  		s.index =3D idx;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1568  		s.num =3D vq->las=
t_avail_idx;
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1569  		if (copy_to_user(=
argp, &s, sizeof s))
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1570  			r =3D -EFAULT;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1571  		break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1572  	case VHOST_SET_VRI=
NG_KICK:
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1573  		if (copy_from_use=
r(&f, argp, sizeof f)) {
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1574  			r =3D -EFAULT;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1575  			break;
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1576  		}
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14 @1577  		eventfp =3D f.fd =
=3D=3D -1 ? NULL : eventfd_fget(f.fd);
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1578  		if (IS_ERR(eventf=
p)) {
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1579  			r =3D PTR_ERR(ev=
entfp);
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1580  			break;
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1581  		}
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1582  		if (eventfp !=3D =
vq->kick) {
> cecb46f194460d Al Viro            2012-08-27  1583  			pollstop =3D (fi=
lep =3D vq->kick) !=3D NULL;
> cecb46f194460d Al Viro            2012-08-27  1584  			pollstart =3D (v=
q->kick =3D eventfp) !=3D NULL;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1585  		} else
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1586  			filep =3D eventf=
p;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1587  		break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1588  	case VHOST_SET_VRI=
NG_CALL:
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1589  		if (copy_from_use=
r(&f, argp, sizeof f)) {
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1590  			r =3D -EFAULT;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1591  			break;
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1592  		}
> e050c7d93f4adb Eric Biggers       2018-01-06  1593  		ctx =3D f.fd =3D=3D=
 -1 ? NULL : eventfd_ctx_fdget(f.fd);
> e050c7d93f4adb Eric Biggers       2018-01-06  1594  		if (IS_ERR(ctx)) =
{
> e050c7d93f4adb Eric Biggers       2018-01-06  1595  			r =3D PTR_ERR(ct=
x);
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1596  			break;
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1597  		}
> e050c7d93f4adb Eric Biggers       2018-01-06  1598  		swap(ctx, vq->cal=
l_ctx);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1599  		break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1600  	case VHOST_SET_VRI=
NG_ERR:
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1601  		if (copy_from_use=
r(&f, argp, sizeof f)) {
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1602  			r =3D -EFAULT;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1603  			break;
> 7ad9c9d2704854 Takuya Yoshikawa   2010-05-27  1604  		}
> 09f332a589232f Eric Biggers       2018-01-06  1605  		ctx =3D f.fd =3D=3D=
 -1 ? NULL : eventfd_ctx_fdget(f.fd);
> 09f332a589232f Eric Biggers       2018-01-06  1606  		if (IS_ERR(ctx)) =
{
> 09f332a589232f Eric Biggers       2018-01-06  1607  			r =3D PTR_ERR(ct=
x);
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1608  			break;
> 535297a6ae4c3b Michael S. Tsirkin 2010-03-17  1609  		}
> 09f332a589232f Eric Biggers       2018-01-06  1610  		swap(ctx, vq->err=
or_ctx);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1611  		break;
> 2751c9882b9472 Greg Kurz          2015-04-24  1612  	case VHOST_SET_VRI=
NG_ENDIAN:
> 2751c9882b9472 Greg Kurz          2015-04-24  1613  		r =3D vhost_set_v=
ring_endian(vq, argp);
> 2751c9882b9472 Greg Kurz          2015-04-24  1614  		break;
> 2751c9882b9472 Greg Kurz          2015-04-24  1615  	case VHOST_GET_VRI=
NG_ENDIAN:
> 2751c9882b9472 Greg Kurz          2015-04-24  1616  		r =3D vhost_get_v=
ring_endian(vq, idx, argp);
> 2751c9882b9472 Greg Kurz          2015-04-24  1617  		break;
> 03088137246065 Jason Wang         2016-03-04  1618  	case VHOST_SET_VRI=
NG_BUSYLOOP_TIMEOUT:
> 03088137246065 Jason Wang         2016-03-04  1619  		if (copy_from_use=
r(&s, argp, sizeof(s))) {
> 03088137246065 Jason Wang         2016-03-04  1620  			r =3D -EFAULT;
> 03088137246065 Jason Wang         2016-03-04  1621  			break;
> 03088137246065 Jason Wang         2016-03-04  1622  		}
> 03088137246065 Jason Wang         2016-03-04  1623  		vq->busyloop_time=
out =3D s.num;
> 03088137246065 Jason Wang         2016-03-04  1624  		break;
> 03088137246065 Jason Wang         2016-03-04  1625  	case VHOST_GET_VRI=
NG_BUSYLOOP_TIMEOUT:
> 03088137246065 Jason Wang         2016-03-04  1626  		s.index =3D idx;
> 03088137246065 Jason Wang         2016-03-04  1627  		s.num =3D vq->bus=
yloop_timeout;
> 03088137246065 Jason Wang         2016-03-04  1628  		if (copy_to_user(=
argp, &s, sizeof(s)))
> 03088137246065 Jason Wang         2016-03-04  1629  			r =3D -EFAULT;
> 03088137246065 Jason Wang         2016-03-04  1630  		break;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1631  	default:
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1632  		r =3D -ENOIOCTLCM=
D;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1633  	}
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1634
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1635  	if (pollstop && vq=
->handle_kick)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1636  		vhost_poll_stop(&=
vq->poll);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1637
> e050c7d93f4adb Eric Biggers       2018-01-06  1638  	if (!IS_ERR_OR_NUL=
L(ctx))
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1639  		eventfd_ctx_put(c=
tx);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1640  	if (filep)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1641  		fput(filep);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1642
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1643  	if (pollstart && v=
q->handle_kick)
> 2b8b328b61c799 Jason Wang         2013-01-28  1644  		r =3D vhost_poll_=
start(&vq->poll, vq->kick);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1645
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1646  	mutex_unlock(&vq->=
mutex);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1647
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1648  	if (pollstop && vq=
->handle_kick)
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1649  		vhost_poll_flush(=
&vq->poll);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1650  	return r;
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1651  }
> 6ac1afbf6132df Asias He           2013-05-06  1652  EXPORT_SYMBOL_GPL(v=
host_vring_ioctl);
> 3a4d5c94e95935 Michael S. Tsirkin 2010-01-14  1653
>
> :::::: The code at line 1577 was first introduced by commit
> :::::: 3a4d5c94e959359ece6d6b55045c3f046677f55c vhost_net: a kernel-lev=
el virtio server
>
> :::::: TO: Michael S. Tsirkin <mst@redhat.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

