Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461EAB66AD
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387402AbfIRPEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:04:05 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41802 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbfIRPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 11:04:04 -0400
Received: by mail-io1-f68.google.com with SMTP id r26so16830222ioh.8
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eTC0GsonGORpLvwKVASrabLmJky2gWLFh4NKtN+MXx4=;
        b=PhTyIk52sUSVne4nIPa1LmR5+whIF1mneYUa+27Ct0YAmpG1I3ksH00RunSjsoAx9w
         N8nALRt3D05gc6qsyra27enJdRQ3ORWDOJlfv6J8L1rBjGChsP8qf15f5rgAqD3rdosL
         U+FcXkvXYHcvYOwilb7xspWSSTMlU6lulSokfNMGM+LYSY29VRm6OS2mADfueDav284s
         WLR6RWy5bcAEA0C7gOGXP9aNOYk3YW0LQb9pErwfXpCGeZYllVXWSG8hZ4sPqNHIDzaL
         bInfYCU06ozErEMEJB8Osp98LlFsMkA5B7zZta3sNpGxbe1imFqGKz+xNHpmr9Lc7BLg
         pCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eTC0GsonGORpLvwKVASrabLmJky2gWLFh4NKtN+MXx4=;
        b=aSgxGywcWOlwBpxgodUVICvNkKEIXCSgX5Y3BCyUtbZ92UUCqFSABghIU7H6BHqBF5
         VaRg0e/OyMZPWUiZV0+B6YcCydeSOHXlzcdokaT4ZBObWHXOUhmUd6liLc9A7ktwakO3
         fXfgzXkyNASZ9RF87jJU/G+xMBET0qm5MUDIRZKpZxPD+yZ5QtaUac5EGgZGlmyPkYcF
         zbntjvPF2RLFPIA8TWfgI5XeI73qS/E6i9xZR2fQ36cebX/n/CTSsAQOFq5q86otPPtF
         eAFOobydY74Gnby9ukNMliv2z5LCR2L5U9LO4jJ4qJQWpZ76nmNRkmTh0sD7IdxT6mXX
         xHLQ==
X-Gm-Message-State: APjAAAW1VWIwRdGrDIV4MKiW2Y8DJHlAfPa19VUw2Tj0mPuGw5SD8Eu7
        wKIqDtvGVVQpNOeTaFrvyvrhpHuVgkMkimmlCio=
X-Google-Smtp-Source: APXvYqwXdbrE4ouuG52RlZskn9kMHt3/4Rdlm+LiV6jdL7EAhCkkyXPdD9o3GTdfiZECdcriNuDUHFn6mzlJxTccDRk=
X-Received: by 2002:a5e:8c15:: with SMTP id n21mr5408215ioj.246.1568819042275;
 Wed, 18 Sep 2019 08:04:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190918140225.imqchybuf3cnknob@pengutronix.de> <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
In-Reply-To: <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 18 Sep 2019 08:03:50 -0700
Message-ID: <CAA93jw6xB5uv48nB_rgtsky3mGthU2cjMMhuK_NFQeBxio4q5Q@mail.gmail.com>
Subject: Re: dsa traffic priorization
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 7:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Sascha,
>
> On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote=
:
> >
> > Hi All,
> >
> > We have a customer using a Marvell 88e6240 switch with Ethercat on one =
port and
> > regular network traffic on another port. The customer wants to configur=
e two things
> > on the switch: First Ethercat traffic shall be priorized over other net=
work traffic
> > (effectively prioritizing traffic based on port). Second the ethernet c=
ontroller
> > in the CPU is not able to handle full bandwidth traffic, so the traffic=
 to the CPU
> > port shall be rate limited.
> >
>
> You probably already know this, but egress shaping will not drop
> frames, just let them accumulate in the egress queue until something
> else happens (e.g. queue occupancy threshold triggers pause frames, or
> tail dropping is enabled, etc). Is this what you want? It sounds a bit

Dropping in general is a basic attribute of the fq_codel algorithm which is
enabled by default on many boxes. It's latency sensitive, so it responds we=
ll
to pause frame (over) use.

Usually the cpu to switch port is exposed via vlan (e.g eth0:2), and
while you can inbound and
outbound shape on that - using htb/hfsc +  fq_codel, or cake

But, also, most usually what happens when the cpu cannot keep up with
the switch is we drop packets on the rx ring for receive, and in
fq-codel on send.

> strange to me to configure egress shaping on the CPU port of a DSA
> switch. That literally means you are buffering frames inside the
> system. What about ingress policing?
>
> > For reference the patch below configures the switch to their needs. Now=
 the question
> > is how this can be implemented in a way suitable for mainline. It looks=
 like the per
> > port priority mapping for VLAN tagged packets could be done via ip link=
 add link ...
> > ingress-qos-map QOS-MAP. How the default priority would be set is uncle=
ar to me.
> >
>
> Technically, configuring a match-all rxnfc rule with ethtool would
> count as 'default priority' - I have proposed that before. Now I'm not
> entirely sure how intuitive it is, but I'm also interested in being
> able to configure this.
>
> > The other part of the problem seems to be that the CPU port has no netw=
ork device
> > representation in Linux, so there's no interface to configure the egres=
s limits via tc.
> > This has been discussed before, but it seems there hasn't been any cons=
ensous regarding how
> > we want to proceed?
> >
> > Sascha
> >
> > -----------------------------8<-----------------------------------
> >
> >  drivers/net/dsa/mv88e6xxx/chip.c | 54 +++++++++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/port.c | 87 ++++++++++++++++++++++++++++++++
> >  drivers/net/dsa/mv88e6xxx/port.h | 19 +++++++
> >  3 files changed, 159 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6x=
xx/chip.c
> > index d0a97eb73a37..2a15cf259d04 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -2090,7 +2090,9 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_=
chip *chip, int port)
> >  {
> >          struct dsa_switch *ds =3D chip->ds;
> >          int err;
> > +        u16 addr;
> >          u16 reg;
> > +        u16 val;
> >
> >          chip->ports[port].chip =3D chip;
> >          chip->ports[port].port =3D port;
> > @@ -2246,7 +2248,57 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx=
_chip *chip, int port)
> >          /* Default VLAN ID and priority: don't set a default VLAN
> >           * ID, and set the default packet priority to zero.
> >           */
> > -        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT=
_VLAN, 0);
> > +        err =3D mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAUL=
T_VLAN, 0);
> > +        if (err)
> > +                return err;
> > +
> > +#define SWITCH_CPU_PORT 5
> > +#define SWITCH_ETHERCAT_PORT 3
> > +
> > +        /* set the egress rate */
> > +        switch (port) {
> > +                case SWITCH_CPU_PORT:
> > +                        err =3D mv88e6xxx_port_set_egress_rate(chip, p=
ort,
> > +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL=
2_COUNT_MODE_FRAME, 30000);
> > +                        break;
> > +                default:
> > +                        err =3D mv88e6xxx_port_set_egress_rate(chip, p=
ort,
> > +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL=
2_COUNT_MODE_FRAME, 0);
> > +                        break;
> > +        }
> > +
> > +        if (err)
> > +                return err;
> > +
> > +        /* set the output queue usage */
> > +        switch (port) {
> > +                case SWITCH_CPU_PORT:
> > +                        err =3D mv88e6xxx_port_set_output_queue_schedu=
le(chip, port,
> > +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL=
2_SCHEDULE_Q3_STRICT);
> > +                        break;
> > +                default:
> > +                        err =3D mv88e6xxx_port_set_output_queue_schedu=
le(chip, port,
> > +                                        MV88E6XXX_PORT_EGRESS_RATE_CTL=
2_SCHEDULE_NONE_STRICT);
> > +                        break;
> > +        }
> > +
> > +        if (err)
> > +                return err;
> > +
> > +        /* set the default QPri */
> > +        switch (port) {
> > +                case SWITCH_ETHERCAT_PORT:
> > +                        err =3D mv88e6xxx_port_set_default_qpri(chip, =
port, 3);
> > +                        break;
> > +                default:
> > +                        err =3D mv88e6xxx_port_set_default_qpri(chip, =
port, 2);
> > +                        break;
> > +        }
> > +
> > +        if (err)
> > +                return err;
> > +
> > +        return 0;
> >  }
> >
> >  static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
> > diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6x=
xx/port.c
> > index 04309ef0a1cc..e03f24308f15 100644
> > --- a/drivers/net/dsa/mv88e6xxx/port.c
> > +++ b/drivers/net/dsa/mv88e6xxx/port.c
> > @@ -1147,6 +1147,22 @@ int mv88e6165_port_set_jumbo_size(struct mv88e6x=
xx_chip *chip, int port,
> >          return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, r=
eg);
> >  }
> >
> > +int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int p=
ort, int qpri)
> > +{
> > +        u16 reg;
> > +        int err;
> > +
> > +        err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &=
reg);
> > +        if (err)
> > +                return err;
> > +
> > +        reg &=3D ~MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
> > +        reg |=3D (qpri << 1) & MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK;
> > +        reg |=3D MV88E6XXX_PORT_CTL2_USE_DEF_QPRI;
> > +
> > +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, r=
eg);
> > +}
> > +
> >  /* Offset 0x09: Port Rate Control */
> >
> >  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, i=
nt port)
> > @@ -1161,6 +1177,77 @@ int mv88e6097_port_egress_rate_limiting(struct m=
v88e6xxx_chip *chip, int port)
> >                                      0x0001);
> >  }
> >
> > +int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *ch=
ip, int port,
> > +                                             u16 schedule)
> > +{
> > +        u16 reg;
> > +        int err;
> > +
> > +        err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_=
RATE_CTL2, &reg);
> > +        if (err)
> > +                return err;
> > +
> > +        reg &=3D ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK;
> > +        reg |=3D schedule;
> > +
> > +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_=
RATE_CTL2, reg);
> > +}
> > +
> > +static int _mv88e6xxx_egress_rate_calc_frames(u32 rate, u16 *egress_ra=
te_val)
> > +{
> > +        const volatile u32 scale_factor =3D (1000 * 1000 * 1000);
> > +        volatile u32 u;
> > +
> > +        if (rate > 1488000)
> > +                return EINVAL;
> > +
> > +        if (rate < 7600)
> > +                return EINVAL;
> > +
> > +        u =3D 32 * rate;
> > +        u =3D scale_factor / u; /* scale_factor used to convert 32s in=
to 32ns */
> > +
> > +        *egress_rate_val =3D (u16)u;
> > +
> > +        return 0;
> > +}
> > +
> > +int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int po=
rt, u16 type,
> > +                                   u32 rate)
> > +{
> > +        u16 reg;
> > +        int err;
> > +        u16 egress_rate_val;
> > +
> > +        err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_EGRESS_=
RATE_CTL2, &reg);
> > +        if (err)
> > +                return err;
> > +
> > +        reg &=3D ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK;
> > +
> > +        if (rate) {
> > +                reg &=3D ~MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_M=
ASK;
> > +                reg |=3D type;
> > +
> > +                switch (type) {
> > +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MOD=
E_FRAME:
> > +                                err =3D _mv88e6xxx_egress_rate_calc_fr=
ames(rate, &egress_rate_val);
> > +                                if (err)
> > +                                        return err;
> > +                                reg |=3D egress_rate_val & 0x0FFF;
> > +                                break;
> > +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MOD=
E_L1:
> > +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MOD=
E_L2:
> > +                        case MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MOD=
E_L3:
> > +                                return EINVAL; /* ToDo */
> > +                        default:
> > +                                return EINVAL;
> > +                }
> > +        }
> > +
> > +        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_EGRESS_=
RATE_CTL2, reg);
> > +}
> > +
> >  /* Offset 0x0C: Port ATU Control */
> >
> >  int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, in=
t port)
> > diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6x=
xx/port.h
> > index 8d5a6cd6fb19..cdd057c52ab8 100644
> > --- a/drivers/net/dsa/mv88e6xxx/port.h
> > +++ b/drivers/net/dsa/mv88e6xxx/port.h
> > @@ -197,6 +197,8 @@
> >  #define MV88E6XXX_PORT_CTL2_DEFAULT_FORWARD                0x0040
> >  #define MV88E6XXX_PORT_CTL2_EGRESS_MONITOR                0x0020
> >  #define MV88E6XXX_PORT_CTL2_INGRESS_MONITOR                0x0010
> > +#define MV88E6XXX_PORT_CTL2_USE_DEF_QPRI        0x0008
> > +#define MV88E6XXX_PORT_CTL2_DEF_QPRI_MASK        0x0006
> >  #define MV88E6095_PORT_CTL2_CPU_PORT_MASK                0x000f
> >
> >  /* Offset 0x09: Egress Rate Control */
> > @@ -204,6 +206,17 @@
> >
> >  /* Offset 0x0A: Egress Rate Control 2 */
> >  #define MV88E6XXX_PORT_EGRESS_RATE_CTL2                0x0a
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_MASK 0xC000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_FRAME 0x0000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L1 0x4000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L2 0x8000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_COUNT_MODE_L3 0xC000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_MASK 0x3000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_NONE_STRICT 0x0000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_STRICT 0x1000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_Q3_Q2_STRICT 0x2000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_SCHEDULE_ALL_STRICT 0x3000
> > +#define MV88E6XXX_PORT_EGRESS_RATE_CTL2_RATE_MASK 0x0FFF
> >
> >  /* Offset 0x0B: Port Association Vector */
> >  #define MV88E6XXX_PORT_ASSOC_VECTOR                        0x0b
> > @@ -326,8 +339,14 @@ int mv88e6xxx_port_set_message_port(struct mv88e6x=
xx_chip *chip, int port,
> >                                      bool message_port);
> >  int mv88e6165_port_set_jumbo_size(struct mv88e6xxx_chip *chip, int por=
t,
> >                                    size_t size);
> > +int mv88e6xxx_port_set_default_qpri(struct mv88e6xxx_chip *chip, int p=
ort,
> > +                                  int qpri);
> >  int mv88e6095_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, i=
nt port);
> >  int mv88e6097_port_egress_rate_limiting(struct mv88e6xxx_chip *chip, i=
nt port);
> > +int mv88e6xxx_port_set_output_queue_schedule(struct mv88e6xxx_chip *ch=
ip, int port,
> > +                                  u16 schedule);
> > +int mv88e6xxx_port_set_egress_rate(struct mv88e6xxx_chip *chip, int po=
rt,
> > +                                  u16 type, u32 rate);
> >  int mv88e6097_port_pause_limit(struct mv88e6xxx_chip *chip, int port, =
u8 in,
> >                                 u8 out);
> >  int mv88e6390_port_pause_limit(struct mv88e6xxx_chip *chip, int port, =
u8 in,
> > --
> > 2.23.0
> >
> > --
> > Pengutronix e.K.                           |                           =
  |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |
>
> Regards,
> -Vladimir



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
