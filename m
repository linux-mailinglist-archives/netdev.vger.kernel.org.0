Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE86E0394
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388951AbfJVMGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:06:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41748 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388305AbfJVMGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 08:06:01 -0400
Received: by mail-qt1-f196.google.com with SMTP id c17so23319827qtn.8
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 05:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r0iZ55dso1fmw+gN/by+am4qGX3T5Je4YT5WN3QsuBg=;
        b=Es6sgpTlCyuraa60joW/NGzmi2Wf0L93jrMniHdiPxWQVnm3yrWl6wur06ApqdJwsn
         qLnWQ8BU/xHkqvfefqspm/RYmG1QN6M/RyHlNXF9fyBgIGJCd4IaK3+btb0SxDyRyG7d
         ZMs7DIRl99yHYb0MTz8E7QYO2a0/TXzAj1wkBE4FuA5yDc+Bv7ldiZbNFyoTty0skz4w
         aC6lv2olVNFtlJhdykNjfdgtNG7Ia0zZvAcvvtI2aE4lvAU3S/29rPNN9l+M0V6sTiFe
         pwtHHKWJ81cgMJYkh4iqQP3zJVDRO5BYf7GuVPifUR98xlcZNTyoZzkheNXAVKJcjYND
         qkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r0iZ55dso1fmw+gN/by+am4qGX3T5Je4YT5WN3QsuBg=;
        b=KvrM9j/StkOEoXl84V9ESXQ6QPtwYicCu7unMf9b1YEy+VgYwEVJfr8rQdgL9sr8z5
         AzBsW+jtEOSKajTmYJmME74bIjNsm7EAwt/shAvjlvpSjlSoKqC9VBhzlRgFrV4iR6pK
         0b5C1rf0Or9Q4QDmOrQdkdqVxQtSHgESTi4D9Bz9pwI4DKDaM3up+C0Fje71ix0FnMDV
         cl3lWGsl4PkBSjvVunYanmzxSI0G6WgUW6xwPUy+2ertezhwqMwAI+QN2Igv0hC5PQCs
         VWoagdeBmLk6Y+KOJsdWbSnBhpu8oIYQpEj5aCzh+JeJolMKXyP2aQmobW0uor5feV6U
         rpXQ==
X-Gm-Message-State: APjAAAXLDBYLl7LhIwk1tmynuqf2QJaUMo1FNFzRryNojArmsDrXtEXs
        5mAimZjPdaJzxDXiOvZE2v9MkIp0x8O5y2bRe+FyZQ==
X-Google-Smtp-Source: APXvYqxEHLR3bzBdIPWPBIRum1txqp+LPRLo6NgfTIPbgFE65g2X0yxpbuvxTW0fY/VFJniWC5KcXnSp/UnoOCXr0q4=
X-Received: by 2002:a0c:fd63:: with SMTP id k3mr2649247qvs.185.1571745959655;
 Tue, 22 Oct 2019 05:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
 <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
 <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
 <10497.1569049560@nyx> <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
 <16538.1569371467@famine>
In-Reply-To: <16538.1569371467@famine>
From:   Aleksei Zakharov <zaharov@selectel.ru>
Date:   Tue, 22 Oct 2019 15:05:48 +0300
Message-ID: <CAJYOGF8s+vUzfPFAdibzijdOtsDyXCv-VBHoMUq243jf=Aa9uA@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "zhangsha (A)" <zhangsha.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=81=D1=80, 25 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:31, Jay V=
osburgh <jay.vosburgh@canonical.com>:
>
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=97=D0=B0=D1=85=D0=B0=D1=80=
=D0=BE=D0=B2 wrote:
> [...]
> >Right after reboot one of the slaves hangs with actor port state 71
> >and partner port state 1.
> >It doesn't send lacpdu and seems to be broken.
> >Setting link down and up again fixes slave state.
> [...]
>
>         I think I see what failed in the first patch, could you test the
> following patch?  This one is for net-next, so you'd need to again swap
> slave_err / netdev_err for the Ubuntu 4.15 kernel.
>
>         Thanks,
>
>         -J
>
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
> index 931d9d935686..5e248588259a 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1617,6 +1617,7 @@ int bond_enslave(struct net_device *bond_dev, struc=
t net_device *slave_dev,
>         if (bond->params.miimon) {
>                 if (bond_check_dev_link(bond, slave_dev, 0) =3D=3D BMSR_L=
STATUS) {
>                         if (bond->params.updelay) {
> +/*XXX*/slave_info(bond_dev, slave_dev, "BOND_LINK_BACK initial state\n")=
;
>                                 bond_set_slave_link_state(new_slave,
>                                                           BOND_LINK_BACK,
>                                                           BOND_SLAVE_NOTI=
FY_NOW);
> @@ -2086,8 +2087,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>         ignore_updelay =3D !rcu_dereference(bond->curr_active_slave);
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> -               slave->link_new_state =3D slave->link;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 link_state =3D bond_check_dev_link(bond, slave->dev, 0);
>
> @@ -2096,8 +2096,6 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                         if (link_state)
>                                 continue;
>
> -                       bond_propose_link_state(slave, BOND_LINK_FAIL);
> -                       commit++;
>                         slave->delay =3D bond->params.downdelay;
>                         if (slave->delay) {
>                                 slave_info(bond->dev, slave->dev, "link s=
tatus down for %sinterface, disabling it in %d ms\n",
> @@ -2106,6 +2104,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                                             (bond_is_active_slave(slave) =
?
>                                              "active " : "backup ") : "",
>                                            bond->params.downdelay * bond-=
>params.miimon);
> +                               slave->link =3D BOND_LINK_FAIL;
>                         }
>                         /*FALLTHRU*/
>                 case BOND_LINK_FAIL:
> @@ -2121,7 +2120,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                         }
>
>                         if (slave->delay <=3D 0) {
> -                               slave->new_link =3D BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_=
DOWN);
>                                 commit++;
>                                 continue;
>                         }
> @@ -2133,15 +2132,13 @@ static int bond_miimon_inspect(struct bonding *bo=
nd)
>                         if (!link_state)
>                                 continue;
>
> -                       bond_propose_link_state(slave, BOND_LINK_BACK);
> -                       commit++;
>                         slave->delay =3D bond->params.updelay;
> -
>                         if (slave->delay) {
>                                 slave_info(bond->dev, slave->dev, "link s=
tatus up, enabling it in %d ms\n",
>                                            ignore_updelay ? 0 :
>                                            bond->params.updelay *
>                                            bond->params.miimon);
> +                               slave->link =3D BOND_LINK_BACK;
>                         }
>                         /*FALLTHRU*/
>                 case BOND_LINK_BACK:
> @@ -2158,7 +2155,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                                 slave->delay =3D 0;
>
>                         if (slave->delay <=3D 0) {
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 commit++;
>                                 ignore_updelay =3D false;
>                                 continue;
> @@ -2196,7 +2193,7 @@ static void bond_miimon_commit(struct bonding *bond=
)
>         struct slave *slave, *primary;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         /* For 802.3ad mode, check current slave speed an=
d
>                          * duplex again in case its port was disabled aft=
er
> @@ -2268,8 +2265,8 @@ static void bond_miimon_commit(struct bonding *bond=
)
>
>                 default:
>                         slave_err(bond->dev, slave->dev, "invalid new lin=
k %d on slave\n",
> -                                 slave->new_link);
> -                       slave->new_link =3D BOND_LINK_NOCHANGE;
> +                                 slave->link_new_state);
> +                       bond_propose_link_state(slave, BOND_LINK_NOCHANGE=
);
>
>                         continue;
>                 }
> @@ -2677,13 +2674,13 @@ static void bond_loadbalance_arp_mon(struct bondi=
ng *bond)
>         bond_for_each_slave_rcu(bond, slave, iter) {
>                 unsigned long trans_start =3D dev_trans_start(slave->dev)=
;
>
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 if (slave->link !=3D BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, trans_start, 1) &=
&
>                             bond_time_in_interval(bond, slave->last_rx, 1=
)) {
>
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 slave_state_changed =3D 1;
>
>                                 /* primary_slave has no meaning in round-=
robin
> @@ -2708,7 +2705,7 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>                         if (!bond_time_in_interval(bond, trans_start, 2) =
||
>                             !bond_time_in_interval(bond, slave->last_rx, =
2)) {
>
> -                               slave->new_link =3D BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_=
DOWN);
>                                 slave_state_changed =3D 1;
>
>                                 if (slave->link_failure_count < UINT_MAX)
> @@ -2739,8 +2736,8 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>                         goto re_arm;
>
>                 bond_for_each_slave(bond, slave, iter) {
> -                       if (slave->new_link !=3D BOND_LINK_NOCHANGE)
> -                               slave->link =3D slave->new_link;
> +                       if (slave->link_new_state !=3D BOND_LINK_NOCHANGE=
)
> +                               slave->link =3D slave->link_new_state;
>                 }
>
>                 if (slave_state_changed) {
> @@ -2763,9 +2760,9 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>  }
>
>  /* Called to inspect slaves for active-backup mode ARP monitor link stat=
e
> - * changes.  Sets new_link in slaves to specify what action should take
> - * place for the slave.  Returns 0 if no changes are found, >0 if change=
s
> - * to link states must be committed.
> + * changes.  Sets proposed link state in slaves to specify what action
> + * should take place for the slave.  Returns 0 if no changes are found, =
>0
> + * if changes to link states must be committed.
>   *
>   * Called with rcu_read_lock held.
>   */
> @@ -2777,12 +2774,12 @@ static int bond_ab_arp_inspect(struct bonding *bo=
nd)
>         int commit =3D 0;
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>                 last_rx =3D slave_last_rx(bond, slave);
>
>                 if (slave->link !=3D BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, last_rx, 1)) {
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 commit++;
>                         }
>                         continue;
> @@ -2810,7 +2807,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
>                 if (!bond_is_active_slave(slave) &&
>                     !rcu_access_pointer(bond->current_arp_slave) &&
>                     !bond_time_in_interval(bond, last_rx, 3)) {
> -                       slave->new_link =3D BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> @@ -2823,7 +2820,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, 2) ||
>                      !bond_time_in_interval(bond, last_rx, 2))) {
> -                       slave->new_link =3D BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>         }
> @@ -2843,7 +2840,7 @@ static void bond_ab_arp_commit(struct bonding *bond=
)
>         struct slave *slave;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2893,8 +2890,9 @@ static void bond_ab_arp_commit(struct bonding *bond=
)
>                         continue;
>
>                 default:
> -                       slave_err(bond->dev, slave->dev, "impossible: new=
_link %d on slave\n",
> -                                 slave->new_link);
> +                       slave_err(bond->dev, slave->dev,
> +                                 "impossible: link_new_state %d on slave=
\n",
> +                                 slave->link_new_state);
>                         continue;
>                 }
>
> @@ -3133,6 +3131,7 @@ static int bond_slave_netdev_event(unsigned long ev=
ent,
>                  * let link-monitoring (miimon) set it right when correct
>                  * speeds/duplex are available.
>                  */
> +/*XXX*/slave_info(bond_dev, slave_dev, "EVENT %lu llu %lu\n", event, sla=
ve->last_link_up);
>                 if (bond_update_speed_duplex(slave) &&
>                     BOND_MODE(bond) =3D=3D BOND_MODE_8023AD) {
>                         if (slave->last_link_up)
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index f7fe45689142..d416af72404b 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -159,7 +159,6 @@ struct slave {
>         unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
>         s8     link;            /* one of BOND_LINK_XXXX */
>         s8     link_new_state;  /* one of BOND_LINK_XXXX */
> -       s8     new_link;
>         u8     backup:1,   /* indicates backup slave. Value corresponds w=
ith
>                               BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
>                inactive:1, /* indicates inactive slave */
> @@ -549,7 +548,7 @@ static inline void bond_propose_link_state(struct sla=
ve *slave, int state)
>
>  static inline void bond_commit_link_state(struct slave *slave, bool noti=
fy)
>  {
> -       if (slave->link =3D=3D slave->link_new_state)
> +       if (slave->link_new_state =3D=3D BOND_LINK_NOCHANGE)
>                 return;
>
>         slave->link =3D slave->link_new_state;
>
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com

Hi! As we haven't found any issues with this patch it seems to work fine.
Will this patch be applied on net-next?


--=20
Best Regards,
Aleksei Zakharov
System administrator
