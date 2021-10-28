Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B43A43F38B
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 01:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhJ1Xko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 19:40:44 -0400
Received: from pop3.jakarta.go.id ([103.209.7.13]:8561 "EHLO
        mail.jakarta.go.id" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhJ1Xkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 19:40:43 -0400
Authentication-Results: mail.jakarta.go.id; spf=None smtp.pra=ses.nakertrans@jakarta.go.id; spf=PermError smtp.mailfrom=ses.nakertrans@jakarta.go.id; spf=None smtp.helo=postmaster@zmtap2.jakarta.go.id
Received-SPF: None (mail.jakarta.go.id: no sender authenticity
  information available from domain of
  ses.nakertrans@jakarta.go.id) identity=pra;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="ses.nakertrans@jakarta.go.id";
  x-conformance=sidf_compatible
Received-SPF: PermError (mail.jakarta.go.id: cannot correctly
  interpret sender authenticity information from domain of
  ses.nakertrans@jakarta.go.id) identity=mailfrom;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="ses.nakertrans@jakarta.go.id";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 a mx ip4:103.209.7.13
  include:_spf.google.com include:_spf.mail.yahoo.com
  include:spf.smtpid.jakarta.go.id ~all"
Received-SPF: None (mail.jakarta.go.id: no sender authenticity
  information available from domain of
  postmaster@zmtap2.jakarta.go.id) identity=helo;
  client-ip=10.15.39.86; receiver=mail.jakarta.go.id;
  envelope-from="ses.nakertrans@jakarta.go.id";
  x-sender="postmaster@zmtap2.jakarta.go.id";
  x-conformance=sidf_compatible
IronPort-SDR: mlqCi7kD2Ew7Q6rP0POJJpPGEI9jUhd56mdSD8VDlL7xOfKNOCa7WoDCM+c1bqpea+nf/L+QI7
 Y/ac2hL6XX5w==
IronPort-PHdr: =?us-ascii?q?A9a23=3Acnge6B9rbK0Ixf9uWcG6ngc9DxPP2p3xNw8Rr?=
 =?us-ascii?q?JguiLtUbq3l8JOkPUCMre51ggrvWoPWo+lBl/KQq7rpDHcN+tCHuXMPaoBWX?=
 =?us-ascii?q?hkeoccfnAU6HMfDBkq9LfK5JzciEpF6WUVg0muhNlIdA8PifxvXq3y24yQVH?=
 =?us-ascii?q?0DkOBEzIO32F5TOlc2xzMiw8p7aeRlBwjW6J7J+f12ttQuEkM4QjMN5L7opj?=
 =?us-ascii?q?BvEpnwdY+NN2WZhPk6ehT7u49u55MQl8S1Tsug9/ohPVuP7c8zUVJR+CzIre?=
 =?us-ascii?q?yAw7czv8xvKTgKV+nJaXWJQkxYaSw7CpAr3WJv8qGPzq/Z91S+GPMb3UaFRO?=
 =?us-ascii?q?3zq7qFlTwXtgTsGMDhx+X/ei8h5hqZW6By7oBk3z4nRaYCTfP1wG8GVNcgXX?=
 =?us-ascii?q?ixHV8VcTTBbC4WnR4kGDOMbIe8eoI67pldP5RqyCA+wBf/+nydSjyyTv+Vy2?=
 =?us-ascii?q?OAgHAfamQ04SotW9i2J6o6kcvdMAqivwaLFzCvOdaZT0Db5rorBcRk7vfjKU?=
 =?us-ascii?q?rU2cMaCrCtnXw7DkFiUrpToej2P0eFY+XOW9KxmXOGikXI9ogdqijqmxc42l?=
 =?us-ascii?q?oCPiYVTy1yOpkAbiM4lYMa1TkJ2e4vuC5ZL8SeTNIZsXtkrRXpAui85w6cas?=
 =?us-ascii?q?Ni0e24LxN50onyXI+zCeI+O7BX5Ue+XKjotn3NpdoW0gBOq+FShwOnxPiWt+?=
 =?us-ascii?q?G5HtC9oiMPLrDhN0hXS7o6FQ/h05FuonzmIkQHfuKlPKEYykraTIJk72LM7i?=
 =?us-ascii?q?p4C1CaLVi7whEjslLWbag0/9+6k5v6va6j6ppKaK45/ix3veqUolMulBO0kM?=
 =?us-ascii?q?w8IF2aB/uH02Lrm9Ez/CLJE659+2rLUq9bcLMcWvLKjCglO+oQq6B+lEz7g3?=
 =?us-ascii?q?9NenHVGZFNJdRSbjpT4blTHIfT2F/C60DHO2H9gw/HLOKGkA42YdyCFyeqnJ?=
 =?us-ascii?q?uc7uxAPgBA+xt1e+Z9OX7QIIfa1WEbyvcbEB1k2NEq1z7WCap0124UAVGaIG?=
 =?us-ascii?q?qLcPrnVtArC/e80Ze+FZ4IPpCz0LeMN5ffthGUlkBkSeu+o0dFEDRLwVuQjO?=
 =?us-ascii?q?EifbXf2150aHHxMuAM9Qfb2klSEShZRbnW7Rb41oD48ToOqR9SmJMjlkPmK2?=
 =?us-ascii?q?yG1GYdTb2ZNBwWXEHvmQI6DXu8FdCOYJsIy2ixBT7WqTJUtkA2/rAKvgaQyN?=
 =?us-ascii?q?fLao2dL0PCrnMgw/eDYkgs+sCB5H9jImX/YVHl6xysBDzomlKFn/R4kkgzFi?=
 =?us-ascii?q?/ApxaMeTIc2hbsBUwExMYPQwr5NEMj8HA3GediNRRCtRdDuADc6Ss89zo05e?=
 =?us-ascii?q?F5zXdCrjxSFziOqBLhTnLuOYf58uqPa1HzsK8sv0G7IkrIkk0EnTo1NPG6vn?=
 =?us-ascii?q?LJ2sQfUQY/F21OQk6LgHUgF9AjK8mrLjW+HvUUeUgdzWL/ZVDYQYQ3XoYax4?=
 =?us-ascii?q?ESKVLKoBbk9egJc1c6PLLdLYdz1nDAkDL/iPtrZeWe4h2a3A16B2LqNaIPgf?=
 =?us-ascii?q?2hV0j/aDQAIlAUa/HDOMgZbZG/pu2XFEDlnDk7ieWv+9PV3sCn9TEY3xhuWZ?=
 =?us-ascii?q?gtu0Py09l9dhPCRTe8SwqNRuColrGYRfh711NbXBtyc4gt5KfwEJ4pgpgwWk?=
 =?us-ascii?q?zKH5ERnM5etLr5vnAsbegVz+UHn1BxtFowGns9srX95qWg6Ya+ezl5FcCuVm?=
 =?us-ascii?q?J7qPbiCYHL/51apYq3bwE3E2dCN0qUG6/0it1ylswbvF0ZooBAFm5FFlmCR4?=
 =?us-ascii?q?JnHFl9YSZXqTkM+7AR3vZnIZzU0/9mS13RvOLOou3nN3JQoCKF2r3ToN8caO?=
 =?us-ascii?q?6SCGgjoFsQcDMX7M+0mlW+iaRccNfxT/qo5VytJX/mP26exIO8mkzXgjGgVv?=
 =?us-ascii?q?uiVM2qe8jZ1UrSO3Z8GyuuE102IUHH9gAX52igSsYJNZjgIAmP5xi+iBYIDP?=
 =?us-ascii?q?sVP?=
IronPort-Data: =?us-ascii?q?A9a23=3Ajd3+P6OVwP5f/IrvrR29ksFynXyQoLVcMsEvi?=
 =?us-ascii?q?/4bfWQNrUp0gzwAz2pLX2GHaPjcYWXyKIskbtyw/UIO757RzN5mGnM5pCpnJ?=
 =?us-ascii?q?55oRWgpJvzCdxutYHnCRiH7ofUOA/w2MrEsF+hpCC+DzvuRGuK59yAljfvYH?=
 =?us-ascii?q?uCU5NPsY0ideyc1EE/Ntjo+w4bVsqYw6TSIK1vlVeHa+qUzC3f5s9JACV/43?=
 =?us-ascii?q?orYwP9ZUFYejxtD1rA2TagjUFYzDBD5BrpHTU26ByOQroW5godW7gsepYxV8?=
 =?us-ascii?q?F81/z91Yj+kuqT+bkQSGPjQNAuHkGZfHaelxBlOzsAw+v9jcqNBLxwGzWXX9?=
 =?us-ascii?q?zxy4IwlWZiYUgoyeKvFm+kHTwNRFTpWP6RF8aXbKD6wtoqSwyUqdlO1maQxU?=
 =?us-ascii?q?htnYeX0/c4yWwmi78cwLj0SWQ+Enea66Ky2UOh+gcJlKsT3VKsZt21swC/xE?=
 =?us-ascii?q?/krW9bATr/M6Nse2y0/7uhIEOzTIdEUaz1ydjzeYhFCJk0QDtQ1lY+AgHTjc?=
 =?us-ascii?q?zBCrFuTqbE85G7I0Qh4zLXFLtvTcc2RWN9b2E2fowru+WnjBRcXZIXH4SSE6?=
 =?us-ascii?q?H2tgu7I2yLnMKoUGaa17fczqEOS3GMSDBwRE1qnydG/h1K+VshbIkoY4S4ps?=
 =?us-ascii?q?bQ/7k2pF/HjXge3oXqFuVgdR7J4FeA97QaWyrfb4i6HAWQNSzdAbJots4kkT?=
 =?us-ascii?q?FQC0FKVgNTzBiZitqGcTWm16LCYpDa7OCxTJmhEdyZsZQ0I+dvquog6pgzIT?=
 =?us-ascii?q?9JqVqCv5vXzFCv3wjaH8XkWmbISicdN2b/T1VbKmCml/8DhUAk04gyRUHjNx?=
 =?us-ascii?q?gV0f5Wpaoql8lvS4/toMoGYSlDHsmJss86T8OUPDteBlQSTR+QJFfen/Z6tN?=
 =?us-ascii?q?jDCjEQpFZ4w3yqq+nqqO45KiBl4KVx1KMccfTL1SFHUuAdYop9PVFOsYLF2Z?=
 =?us-ascii?q?ISwI9otyarpU9LoSpj8aNdJfpV6dAOK+CFvTVCL2WSrm08p+Yk5NImSfc+EE?=
 =?us-ascii?q?20cDeJsyz/eb+EQy74owXAW2mrXQZm9xBOiuZKYaWCSfqwFaXORZ+Q95eWPp?=
 =?us-ascii?q?wC929BSMM+D0FNTWfP/bgHI+IgaIVcNa3YhbbjwptRecuOrPQNgEW0mDLnf2?=
 =?us-ascii?q?9sJfYF/luJNi+jF4lmiU0lRxF34w3PdQS2MZ2piY7S3DL5gpHQyMSsre1iys?=
 =?us-ascii?q?1AlbJyz66IVMYE6eKgP6+VlxPJzSL8LYa2oBPlUUT2B/ikHYoTwsKR9fRKii?=
 =?us-ascii?q?QWJeSS/CBA5coV7RgWP9NLgeg7m8i8mESOxvMc5pPuuzGvzR5cYXAVnStTbc?=
 =?us-ascii?q?viuxXuutH4UlOV1GUXSSvFVdV7w95JgMSvspuA+JcgALhKFyCHy/wCbHVERv?=
 =?us-ascii?q?e3QuKcq+d/AiaeD6Ymze8N4E1YcEnWd5rK/NDPy4WOlyINHV6CGZ1j1Um7o+?=
 =?us-ascii?q?b6zfs1Kxvf1PPoA2lhQ26J6Hqpsi6c5/dTmobJy0Q1iFXnMaBKlENtIJHSb1?=
 =?us-ascii?q?8RVqoVSz7lQtQyxHEyVkvFcNKiMMcXjVkQWIAMjYsyc3Pcdlj7Vq/ovSG386?=
 =?us-ascii?q?TJy9byBF15bFwaFjiVRK7wzPplN6eEspdQX8BeyzB8rOdaLii186G2KJ3AHV?=
 =?us-ascii?q?OMprPkyBoL2lhAszFBJSYPVDCb655bJZc8kGk8nPyGFjqPZhLlAzU7feVIsH?=
 =?us-ascii?q?H7E0e1aw5oU0DhMwUELK13XssXMgPY72xoX/y5fZgJY0BhdyKR4O25mMkRdO?=
 =?us-ascii?q?qyI9jtvg45NRQiEHQxfCQeCvEDzwkkbvHLQSUCkUWuLIndVEeCA4k0EtW5VY?=
 =?us-ascii?q?DlX1K6Rzm/pVjGsctuZ9i0/RghgouDLUtV3/wHFn4apBaytGZQlJz3/g6Koe?=
 =?us-ascii?q?SwIrAfqBesujUvOqe5tuuhqAYX9ODARp6k2F6GF3KodDhuDYmpQKdln8b8WG?=
 =?us-ascii?q?nvfYDio0DSPME2ZZc5HYfDHmWe+BstoDt1CXRi3ymCJtD9zLagBPb5wmPMB+?=
 =?us-ascii?q?9cIdK75JGkA9bCYq1JUXDj4nsTlrH0uX9x2y4A/I4DYbS6LVGOXw3pY81IhZ?=
 =?us-ascii?q?fJsYgKQCeToriWigIhZMdnlFq7vdMl+dF07yuHyvXyWORF79lSbu0XCa8c6C?=
 =?us-ascii?q?gCkJZtEx+PR/mdrXm1Y6u8fkMyK+QO6qchHK9zId8bC3+/QgkeyJBxYZNP9R?=
 =?us-ascii?q?Pwp/Ylgc7fLMIftvr81WnrFkt+OEO9I6a1emQaR3t3fdBFnoMdaZPLR3g=3D?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AJbE+XajFDgFDuU2Y6o7xNi7MtnBQXugji2?=
 =?us-ascii?q?hC6mlwRA09TyX+rbHWoB17726TtN5yMEtNpTnkAsa9qBznhP1ICOUqTNWftW?=
 =?us-ascii?q?rdyQyVxeNZnO7fKlTbckWUnIM9tZuIGJIObOEYeGIK9/oSlzPIburIuOP3i5?=
 =?us-ascii?q?xA0t2ut0uFkjsFV51d?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HhXgDR+nph/1YnDwpaDw4BASsBCQE?=
 =?us-ascii?q?GAQUFASKBW4E6AgEBAQEBYGGBHwQ8C4Q9jUSDFQOBYIRMQIQ+AgECglOIT4Y?=
 =?us-ascii?q?KgXsBCgEBAQEBAQEBARsTHAQBAQMDgTKDSCWCMB8JA0cBAgQBARMBAQYBAQE?=
 =?us-ascii?q?BAQMDBAICgSCFaA2DU4EIAQEBAQEBAQEBAQEBAQEBAQEBARYCH1JHAQQEAS0?=
 =?us-ascii?q?dAQEnARARASICDRkCIzgHEDQBASSCGEcBgg0DCa1JG3qBMYEBgggBAQaCWYI?=
 =?us-ascii?q?5DYJACYEQKAMBAQEBAQGFdoN3hWKBEIFIA4VThTwUglGSO1SeZ4Fsig+SQ2g?=
 =?us-ascii?q?HKIMNmQ+Fby2DWZIVkTamRJEnhHyBCjwHgXRNeoEXCmVcURcCD5Rch1oCRGg?=
 =?us-ascii?q?4AgYBCgEBAwkBgjqOFIEQgRAB?=
X-IPAS-Result: =?us-ascii?q?A2HhXgDR+nph/1YnDwpaDw4BASsBCQEGAQUFASKBW4E6A?=
 =?us-ascii?q?gEBAQEBYGGBHwQ8C4Q9jUSDFQOBYIRMQIQ+AgECglOIT4YKgXsBCgEBAQEBA?=
 =?us-ascii?q?QEBARsTHAQBAQMDgTKDSCWCMB8JA0cBAgQBARMBAQYBAQEBAQMDBAICgSCFa?=
 =?us-ascii?q?A2DU4EIAQEBAQEBAQEBAQEBAQEBAQEBARYCH1JHAQQEAS0dAQEnARARASICD?=
 =?us-ascii?q?RkCIzgHEDQBASSCGEcBgg0DCa1JG3qBMYEBgggBAQaCWYI5DYJACYEQKAMBA?=
 =?us-ascii?q?QEBAQGFdoN3hWKBEIFIA4VThTwUglGSO1SeZ4Fsig+SQ2gHKIMNmQ+Fby2DW?=
 =?us-ascii?q?ZIVkTamRJEnhHyBCjwHgXRNeoEXCmVcURcCD5Rch1oCRGg4AgYBCgEBAwkBg?=
 =?us-ascii?q?jqOFIEQgRAB?=
X-IronPort-AV: E=Sophos;i="5.87,190,1631552400"; 
   d="scan'208";a="12976294"
Received: from zmtap2.jakarta.go.id ([10.15.39.86])
  by mail.jakarta.go.id with ESMTP; 29 Oct 2021 02:38:13 +0700
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id ADE0A6276BAF;
        Fri, 29 Oct 2021 02:38:13 +0700 (WIB)
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 6fMVz-6SNBrX; Fri, 29 Oct 2021 02:38:13 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id C0BCC6276BC2;
        Fri, 29 Oct 2021 02:38:09 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 zmtap2.jakarta.go.id C0BCC6276BC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jakarta.go.id;
        s=zimbra-mail; t=1635449890;
        bh=ket9wQGPBpEx6WIqdSy6e4jzznNT/FBCSFyZOTIJdlo=;
        h=Date:From:Message-ID:MIME-Version;
        b=PUHCkQElzR71tjWWkxja9A78GUNVoXNZQbUDAeXdn6/BADLcQy10PDUWT6gB/p61e
         Nx5pRS2ug+vdszoP5bD61bRUrgYzNXXb/FD8ES15y9iB0IpdQey4UWCnPTQv3bwEef
         CoWyx6EihaCn5xRGTHdACihxoh4DFNQY18/kv0SfbF7G+10qsOHYdhX68dJky+XzHm
         U354Rx/0Vo23RmoPkKSWCdDXFfegJ6e559nLyQa+nZX0g0Cp/yjFmYtz2zT12rv9EH
         IeX5femXU+H3nd3TKU94FW71VZDYfTa5aWyX0IT0wi2kq74pCYEPU3tUuCKZXmbvmr
         7+F+uSzG1nwsQ==
X-Virus-Scanned: amavisd-new at 
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XgbJ5mdztsgF; Fri, 29 Oct 2021 02:38:09 +0700 (WIB)
Received: from zmailbox1.jakarta.go.id (zmailbox1.jakarta.go.id [10.15.39.83])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id C535E6276BAD;
        Fri, 29 Oct 2021 02:37:55 +0700 (WIB)
Date:   Fri, 29 Oct 2021 02:37:55 +0700 (WIB)
From:   LAPORTE Marie-Josepha <ses.nakertrans@jakarta.go.id>
Message-ID: <142846264.470748.1635449875763.JavaMail.zimbra@jakarta.go.id>
Subject: =?utf-8?Q?Tr=C3=A8s_Urgent!?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.15.39.86]
X-Mailer: Zimbra 8.8.15_GA_4173 (zclient/8.8.15_GA_4173)
Thread-Index: az77qWqWv1Eb4iKprc133E7cmw2CMw==
Thread-Topic: =?utf-8?B?VHLDqHM=?= Urgent!
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonjour
Je me nomme Mme Marie-Josepha LAPORTE. Je vous adresse ce message plein d=
=E2=80=99amertume et de solitude. Apr=C3=A8s le ravage sauvage de la premi=
=C3=A8re vague li=C3=A9e =C3=A0 la pand=C3=A9mie du coronavirus, j'ai perdu=
 mon mari et ma fille unique. Souffrant moi-m=C3=AAme du cancer du sein en =
phase terminale et sachant que mes jours sont compt=C3=A9s, je vous contact=
e dans le but de vous faire un don d'un montant de deux millions d'euros po=
ur la r=C3=A9alisation des =C5=93uvres de charit=C3=A9.

-Tr=C3=A8s Urgent: Contacter moi a mon l'adresse personnelle et je vous pri=
e de copier mon adresse pour me r=C3=A9pondre : laporte.mariejosepha@gmail.=
com.

Merci
Mme Josepha LAPORTE
