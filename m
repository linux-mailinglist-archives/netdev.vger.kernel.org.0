Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AFE3FE8DF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 07:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhIBFtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 01:49:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231831AbhIBFte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 01:49:34 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1825Wlw0007950;
        Thu, 2 Sep 2021 01:48:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=in-reply-to : from : to
 : cc : date : message-id : content-transfer-encoding : content-type :
 mime-version : references : subject; s=pp1;
 bh=D0afL8fy8z1jVXSj35R3Rg1PMz7KCo5mx6u2C+dRblc=;
 b=sV+Y0RBcDc6PjvHuH1s/pui8NLpfk0/VC2fJqqt6s21rGtDbdYrbTb6I70wAzVvaLEOX
 L0Vb7SNV34iss7NU05mw2bmK/GcKxIy2KW2dVeX5Sl3LvdtJEVvuHQD4n7CbLVRXHw75
 NK1LDxni5lvIhSBDptnUsJuBXeOxMkgVXD4LZjyxqWfci+9Qw+9hAJawgLYtCwqb8VUh
 ML2BxdR/NcmKBm90BV+KN80MLPZgnt3TvncqE684uuRCGJNZx9u1B6QU7G/l4sRoLCdc
 a7CMzV450C8QgFWZOkCITJuZGUZ5/q+HjqQBlndnVXJAAguWCg2EboDr69TRohasJpm+ MA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3atq779usk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Sep 2021 01:48:25 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1825gs8c020575;
        Thu, 2 Sep 2021 05:48:24 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3atdxdb9xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Sep 2021 05:48:24 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1825mN9o52494832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Sep 2021 05:48:23 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB375112064;
        Thu,  2 Sep 2021 05:48:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8405E112062;
        Thu,  2 Sep 2021 05:48:23 +0000 (GMT)
Received: from mww0331.wdc07m.mail.ibm.com (unknown [9.208.69.64])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Thu,  2 Sep 2021 05:48:23 +0000 (GMT)
In-Reply-To: <20210830171806.119857-2-i.mikhaylov@yadro.com>
From:   "Milton Miller II" <miltonm@us.ibm.com>
To:     "Ivan Mikhaylov" <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Samuel Mendoza-Jonas" <sam@mendozajonas.com>,
        "Brad Ho" <Brad_Ho@phoenix.com>,
        "Paul Fertser" <fercerpav@gmail.com>, openbmc@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Date:   Thu, 2 Sep 2021 05:48:21 +0000
Message-ID: <OF2487FB9E.ECED277D-ON00258741.006BEF89-00258744.001FE4C0@ibm.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <20210830171806.119857-2-i.mikhaylov@yadro.com>
X-Mailer: Lotus Domino Web Server Release 11.0.1FP2HF97   July 2, 2021
X-MIMETrack: Serialize by http on MWW0331/01/M/IBM at 09/02/2021 05:48:21,Serialize
 complete at 09/02/2021 05:48:21
X-Disclaimed: 12091
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YQ7HdwXe7wVdBGXokUQAOWVZBlwpZf0U
X-Proofpoint-ORIG-GUID: YQ7HdwXe7wVdBGXokUQAOWVZBlwpZf0U
Subject: Re:  [PATCH 1/1] net/ncsi: add get MAC address command to get Intel i210
 MAC address
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_01:2021-09-01,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On August 30, 2021, Ivan Mikhaylov" <i.mikhaylov@yadro.com> wrote:
>This patch adds OEM Intel GMA command and response handler for it.



>>>Signed-off-by: Brad Ho <Brad=5FHo@phoenix.com
>>Signed-off-by: Paul Fertser <fercerpav@gmail.com>
>Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>
>---
> net/ncsi/internal.h    |  3 +++
> net/ncsi/ncsi-manage.c | 25 ++++++++++++++++++++++++-
> net/ncsi/ncsi-pkt.h    |  6 ++++++
> net/ncsi/ncsi-rsp.c    | 42
>++++++++++++++++++++++++++++++++++++++++++
> 4 files changed, 75 insertions(+), 1 deletion(-)
>
>diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
>index 0b6cfd3b31e0..03757e76bb6b 100644
>--- a/net/ncsi/internal.h
>+++ b/net/ncsi/internal.h
>@@ -80,6 +80,7 @@ enum {
> #define NCSI=5FOEM=5FMFR=5FBCM=5FID             0x113d
> #define NCSI=5FOEM=5FMFR=5FINTEL=5FID           0x157
> /* Intel specific OEM command */
>+#define NCSI=5FOEM=5FINTEL=5FCMD=5FGMA          0x06   /* CMD ID for Get =
MAC
>*/
> #define NCSI=5FOEM=5FINTEL=5FCMD=5FKEEP=5FPHY     0x20   /* CMD ID for Ke=
ep
>PHY up */
> /* Broadcom specific OEM Command */
> #define NCSI=5FOEM=5FBCM=5FCMD=5FGMA            0x01   /* CMD ID for Get =
MAC
>*/
>@@ -89,6 +90,7 @@ enum {
> #define NCSI=5FOEM=5FMLX=5FCMD=5FSMAF           0x01   /* CMD ID for Set =
MC
>Affinity */
> #define NCSI=5FOEM=5FMLX=5FCMD=5FSMAF=5FPARAM     0x07   /* Parameter for=
 SMAF
>        */
> /* OEM Command payload lengths*/
>+#define NCSI=5FOEM=5FINTEL=5FCMD=5FGMA=5FLEN      5
> #define NCSI=5FOEM=5FINTEL=5FCMD=5FKEEP=5FPHY=5FLEN 7
> #define NCSI=5FOEM=5FBCM=5FCMD=5FGMA=5FLEN        12
> #define NCSI=5FOEM=5FMLX=5FCMD=5FGMA=5FLEN        8
>@@ -99,6 +101,7 @@ enum {
> /* Mac address offset in OEM response */
> #define BCM=5FMAC=5FADDR=5FOFFSET             28
> #define MLX=5FMAC=5FADDR=5FOFFSET             8
>+#define INTEL=5FMAC=5FADDR=5FOFFSET           1
>=20
>=20
> struct ncsi=5Fchannel=5Fversion {
>diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
>index 89c7742cd72e..7121ce2a47c0 100644
>--- a/net/ncsi/ncsi-manage.c
>+++ b/net/ncsi/ncsi-manage.c
>@@ -795,13 +795,36 @@ static int ncsi=5Foem=5Fsmaf=5Fmlx(struct
>ncsi=5Fcmd=5Farg *nca)
> 	return ret;
> }
>=20
>+static int ncsi=5Foem=5Fgma=5Fhandler=5Fintel(struct ncsi=5Fcmd=5Farg *nc=
a)
>+{
>+	unsigned char data[NCSI=5FOEM=5FINTEL=5FCMD=5FGMA=5FLEN];
>+	int ret =3D 0;
>+
>+	nca->payload =3D NCSI=5FOEM=5FINTEL=5FCMD=5FGMA=5FLEN;
>+
>+	memset(data, 0, NCSI=5FOEM=5FINTEL=5FCMD=5FGMA=5FLEN);
>+	*(unsigned int *)data =3D ntohl((=5F=5Fforce
>=5F=5Fbe32)NCSI=5FOEM=5FMFR=5FINTEL=5FID);
>+	data[4] =3D NCSI=5FOEM=5FINTEL=5FCMD=5FGMA;
>+
>+	nca->data =3D data;
>+
>+	ret =3D ncsi=5Fxmit=5Fcmd(nca);
>+	if (ret)
>+		netdev=5Ferr(nca->ndp->ndev.dev,
>+			   "NCSI: Failed to transmit cmd 0x%x during configure\n",
>+			   nca->type);
>+
>+	return ret;
>+}
>+
> /* OEM Command handlers initialization */
> static struct ncsi=5Foem=5Fgma=5Fhandler {
> 	unsigned int	mfr=5Fid;
> 	int		(*handler)(struct ncsi=5Fcmd=5Farg *nca);
> } ncsi=5Foem=5Fgma=5Fhandlers[] =3D {
> 	{ NCSI=5FOEM=5FMFR=5FBCM=5FID, ncsi=5Foem=5Fgma=5Fhandler=5Fbcm },
>-	{ NCSI=5FOEM=5FMFR=5FMLX=5FID, ncsi=5Foem=5Fgma=5Fhandler=5Fmlx }
>+	{ NCSI=5FOEM=5FMFR=5FMLX=5FID, ncsi=5Foem=5Fgma=5Fhandler=5Fmlx },
>+	{ NCSI=5FOEM=5FMFR=5FINTEL=5FID, ncsi=5Foem=5Fgma=5Fhandler=5Fintel }
> };
>=20
> static int ncsi=5Fgma=5Fhandler(struct ncsi=5Fcmd=5Farg *nca, unsigned int
>mf=5Fid)
>diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
>index 80938b338fee..ba66c7dc3a21 100644
>--- a/net/ncsi/ncsi-pkt.h
>+++ b/net/ncsi/ncsi-pkt.h
>@@ -178,6 +178,12 @@ struct ncsi=5Frsp=5Foem=5Fbcm=5Fpkt {
> 	unsigned char           data[];      /* Cmd specific Data */
> };
>=20
>+/* Intel Response Data */
>+struct ncsi=5Frsp=5Foem=5Fintel=5Fpkt {
>+	unsigned char           cmd;         /* OEM Command ID    */
>+	unsigned char           data[];      /* Cmd specific Data */
>+};
>+
> /* Get Link Status */
> struct ncsi=5Frsp=5Fgls=5Fpkt {
> 	struct ncsi=5Frsp=5Fpkt=5Fhdr rsp;        /* Response header   */
>diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
>index d48374894817..6447a09932f5 100644
>--- a/net/ncsi/ncsi-rsp.c
>+++ b/net/ncsi/ncsi-rsp.c
>@@ -699,9 +699,51 @@ static int ncsi=5Frsp=5Fhandler=5Foem=5Fbcm(struct
>ncsi=5Frequest *nr)
> 	return 0;
> }
>=20
>+/* Response handler for Intel command Get Mac Address */
>+static int ncsi=5Frsp=5Fhandler=5Foem=5Fintel=5Fgma(struct ncsi=5Frequest=
 *nr)
>+{
>+	struct ncsi=5Fdev=5Fpriv *ndp =3D nr->ndp;
>+	struct net=5Fdevice *ndev =3D ndp->ndev.dev;
>+	const struct net=5Fdevice=5Fops *ops =3D ndev->netdev=5Fops;
>+	struct ncsi=5Frsp=5Foem=5Fpkt *rsp;
>+	struct sockaddr saddr;
>+	int ret =3D 0;
>+
>+	/* Get the response header */
>+	rsp =3D (struct ncsi=5Frsp=5Foem=5Fpkt *)skb=5Fnetwork=5Fheader(nr->rsp);
>+
>+	saddr.sa=5Ffamily =3D ndev->type;
>+	ndev->priv=5Fflags |=3D IFF=5FLIVE=5FADDR=5FCHANGE;
>+	memcpy(saddr.sa=5Fdata, &rsp->data[INTEL=5FMAC=5FADDR=5FOFFSET], ETH=5FA=
LEN);
>+	/* Increase mac address by 1 for BMC's address */
>+	eth=5Faddr=5Finc((u8 *)saddr.sa=5Fdata);
>+	if (!is=5Fvalid=5Fether=5Faddr((const u8 *)saddr.sa=5Fdata))
>+		return -ENXIO;

The Intel GMA retireves the MAC address of the host, and the datasheet
anticipates the BMC will "share" the MAC by stealing specific TCP and=20
UDP port traffic destined to the host.

This "add one" allocation of the MAC is therefore a policy, and one that=20
is beyond the data sheet.

While this +1 policy may work for some OEM boards, there are other boards=20
where the MAC address assigned to the BMC does not follow this pattern,=20
but instead the MAC is stored in some platform dependent location obtained =

in a platform specific manner.

I suggest this BMC =3D ether=5Faddr=5Finc(GMA) be opt in via a device tree =
property. =20

The name of the property should be negotiated in the device tree mailing li=
st,=20
as it appears it would be generic to more than one vendor.

Unfortunately, we missed this when we added the broadcom and mellanox handl=
ers.


>+>+	/* Set the flag for GMA command which should only be called once */
>+	ndp->gma=5Fflag =3D 1;
>+
>+	ret =3D ops->ndo=5Fset=5Fmac=5Faddress(ndev, &saddr);
>+	if (ret < 0)
>+		netdev=5Fwarn(ndev,
>+			    "NCSI: 'Writing mac address to device failed\n");
>+
>+	return ret;
>+}
>+
> /* Response handler for Intel card */
> static int ncsi=5Frsp=5Fhandler=5Foem=5Fintel(struct ncsi=5Frequest *nr)
> {
>+	struct ncsi=5Frsp=5Foem=5Fintel=5Fpkt *intel;
>+	struct ncsi=5Frsp=5Foem=5Fpkt *rsp;
>+
>+	/* Get the response header */
>+	rsp =3D (struct ncsi=5Frsp=5Foem=5Fpkt *)skb=5Fnetwork=5Fheader(nr->rsp);
>+	intel =3D (struct ncsi=5Frsp=5Foem=5Fintel=5Fpkt *)(rsp->data);
>+
>+	if (intel->cmd =3D=3D NCSI=5FOEM=5FINTEL=5FCMD=5FGMA)
>+		return ncsi=5Frsp=5Fhandler=5Foem=5Fintel=5Fgma(nr);
>+
> 	return 0;
> }
>=20
>--=20
>2.31.1
>
>
