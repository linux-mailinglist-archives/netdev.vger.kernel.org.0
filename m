Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68DC421EFE
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhJEGrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:47:01 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27234 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231751AbhJEGq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 02:46:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1956C0Nh003700;
        Tue, 5 Oct 2021 02:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=in-reply-to : from : to
 : cc : date : message-id : content-type : references :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=pPNWkNRfEsRJAAVYmHmXPa0lB82wL+NbFspwM37jvaQ=;
 b=sJSJVKM0feq+rxyH9DwjBCnItFv8fO/V3/12Ss8dQwbev7R/04OKAK21erOrs76AjB4g
 6Woi6p0OQDqRkmSS7Y2VXyatzLoaVtYQeXKaeaLIWFVroRNswdWRiXHd034ZvbUZvp50
 3F30ZY2qhdxrVeatN8Kcg+HoeivKpbLevopI6LuN1BzksG483siT/6QbJK9IXuGt1fjE
 Nse8vtgcnTA6rxZgyLT5lhtFTDy27sfJW4A3P4U/ZRP6iM/N19kaRt/ANkNwPVxMQFZf
 Medi3UQs5KST2Im1NJWG0WdJkdcUA38BFZVUqxGwFRKCGBo11aSNomcNPw1nmaZLg07s Ag== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgh7j8kpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 02:44:56 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1956bE30020060;
        Tue, 5 Oct 2021 06:44:55 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02wdc.us.ibm.com with ESMTP id 3bef2adcss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 06:44:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1956isNK36438486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 06:44:54 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2540B6E059;
        Tue,  5 Oct 2021 06:44:54 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BC66E058;
        Tue,  5 Oct 2021 06:44:53 +0000 (GMT)
Received: from mww0332.dal12m.mail.ibm.com (unknown [9.208.69.80])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Tue,  5 Oct 2021 06:44:53 +0000 (GMT)
In-Reply-To: <cb9dedaf242264f76eca18e94934703300be5a7e.camel@yadro.com>
From:   "Milton Miller II" <miltonm@us.ibm.com>
To:     "Ivan Mikhaylov" <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Samuel Mendoza-Jonas" <sam@mendozajonas.com>,
        "Brad Ho" <Brad_Ho@phoenix.com>,
        "Paul Fertser" <fercerpav@gmail.com>, <openbmc@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        "Ricardo Del Pozo Gonzalez" <ricardopozo@es.ibm.com>
Date:   Tue, 5 Oct 2021 06:44:52 +0000
Message-ID: <OF8E108F72.39D22E89-ON00258765.001E46EB-00258765.00251157@ibm.com>
Content-Type: text/plain; charset=UTF-8
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
References: <cb9dedaf242264f76eca18e94934703300be5a7e.camel@yadro.com>,<20210830171806.119857-2-i.mikhaylov@yadro.com>
 <OF2487FB9E.ECED277D-ON00258741.006BEF89-00258744.001FE4C0@ibm.com>
X-Mailer: Lotus Domino Web Server Release 11.0.1FP2HF114   September 2, 2021
X-MIMETrack: Serialize by http on MWW0332/03/M/IBM at 10/05/2021 06:44:52,Serialize
 complete at 10/05/2021 06:44:52
X-Disclaimed: 11143
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: j5JPjlJWzfLnVUmGLkRIH9-0XOo268Ag
X-Proofpoint-ORIG-GUID: j5JPjlJWzfLnVUmGLkRIH9-0XOo268Ag
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
Subject: RE:  [PATCH 1/1] net/ncsi: add get MAC address command to get Intel i210
 MAC address
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1011 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On September 2, 2021, Ivan Mikhaylov wrote:

>On Thu, 2021-09-02 at 05:48 +0000, Milton Miller II wrote:
>> On August 30, 2021, Ivan Mikhaylov" <i.mikhaylov@yadro.com> wrote:
>> > This patch adds OEM Intel GMA command and response handler for
>it.
>> >=20
>> > /* Get Link Status */
>> > struct ncsi_rsp_gls_pkt {
>> >         struct ncsi_rsp_pkt_hdr rsp;        /* Response header
>*/
>> > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
>> > index d48374894817..6447a09932f5 100644
>> > --- a/net/ncsi/ncsi-rsp.c
>> > +++ b/net/ncsi/ncsi-rsp.c
>> > @@ -699,9 +699,51 @@ static int ncsi_rsp_handler_oem_bcm(struct
>> > ncsi_request *nr)
>> >         return 0;
>> > }
>> >=20
>> > +/* Response handler for Intel command Get Mac Address */
>> > +static int ncsi_rsp_handler_oem_intel_gma(struct ncsi_request
>*nr)
>> > +{
>> > +       struct ncsi_dev_priv *ndp =3D nr->ndp;
>> > +       struct net_device *ndev =3D ndp->ndev.dev;
>> > +       const struct net_device_ops *ops =3D ndev->netdev_ops;
>> > +       struct ncsi_rsp_oem_pkt *rsp;
>> > +       struct sockaddr saddr;
>> > +       int ret =3D 0;
>> > +
>> > +       /* Get the response header */
>> > +       rsp =3D (struct ncsi_rsp_oem_pkt
>*)skb_network_header(nr->rsp);
>> > +
>> > +       saddr.sa_family =3D ndev->type;
>> > +       ndev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE;
>> > +       memcpy(saddr.sa_data, &rsp->data[INTEL_MAC_ADDR_OFFSET],
>ETH_ALEN);
>> > +       /* Increase mac address by 1 for BMC's address */
>> > +       eth_addr_inc((u8 *)saddr.sa_data);
>> > +       if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
>> > +               return -ENXIO;
>>=20
>> The Intel GMA retireves the MAC address of the host, and the
>datasheet
>> anticipates the BMC will "share" the MAC by stealing specific TCP
>and=20
>> UDP port traffic destined to the host.
>>=20
>> This "add one" allocation of the MAC is therefore a policy, and one
>that=20
>> is beyond the data sheet.
>>=20
>> While this +1 policy may work for some OEM boards, there are other
>boards=20
>> where the MAC address assigned to the BMC does not follow this
>pattern,=20
>> but instead the MAC is stored in some platform dependent location
>obtained=20
>> in a platform specific manner.
>>=20
>> I suggest this BMC =3D ether_addr_inc(GMA) be opt in via a device
>tree
>> property.=20=20
>>=20
>> as it appears it would be generic to more than one vendor.
>>=20
>> Unfortunately, we missed this when we added the broadcom and
>mellanox
>> handlers.
>>=20
>>=20
>>=20
>
>Milton,
>
>maybe something like "mac_addr_inc" or "ncsi,mac_addr_inc"? Also
>those 3(intel,
>mellanox, broadcom) functions even with handlers similar to each
>other, they
>could be unified on idea, difference in addresses, payload lengths,
>ids only as
>I see. Joel proposed in the past about dts option for Intel OEM
>keep_phy option,
>maybe that's the right time to reorganize all OEM related parts to
>fit in one
>direction with dts options for ethernet interface without Kconfig
>options?

I was hopping to get some feed back from device tree maintainers.=20
I hope we can get something decided before we have to ask for a=20
revert.=20=20

Since the existing properties are mac-address and local-mac-address,=20
I feel the new property should build upon the former like the later.=20=20
I think the most general would be to have an offset that could be=20
positive or negative.  I don't think we necessarily need the full=20
range of address offset as I expect the upper bytes would be remain=20
the assigned block but maybe some would want a large offset in the=20
administrativly set address space?  or buy 2 ranges and assign one=20
from each?

Anyways, I propose one of

mac-address-host-offset
host-mac-address-offset

how do we make it clear its the offset from the host to the BMC not=20
from the BMC to the host?   Is the description in the binding enough?

Do we need more than 3 bytes offset?  How should we represent a=20
decrement vs an increment?  sign extend a u32?  two cells for u64?
treat the first byte as add or subtract and the rest the offset?  Do=20
we need a separate property name to subtract?

My system stores the MAC for the BMC elsewhere but we need a=20
way to opt out of using an offset from the host, hence the need of
at least some property to opt in.





Some background for Rob (and others):

DTMF spec DSP0222 NC-SI (network controller sideband interface)
is a method to provide a BMC (Baseboard management controller) shared
access to an external ethernet port for comunication to the management
network in the outside world.  The protocol describes ethernet packets=20
that control selective bridging implemented in a host network controller
to share its phy.  Various NIC OEMs have added a query to find out the=20
address the host is using, and some vendors have added code to query host
nic and set the BMC mac to a fixed offset (current hard coded +1 from
the host value).  If this is compiled in the kernel, the NIC OEM is=20
recognised and the BMC doesn't miss the NIC response the address is set
once each time the NCSI stack reinitializes.  This mechanism overrides
any mac-address or local-mac-address or other assignment.

DSP0222 https://www.dmtf.org/documents/pmci/network-controller-sideband-int=
erface-nc-si-specification-110

milton

