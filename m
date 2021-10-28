Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A599143F386
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 01:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhJ1XkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 19:40:13 -0400
Received: from pop3.jakarta.go.id ([103.209.7.13]:8311 "EHLO
        mail.jakarta.go.id" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhJ1XkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 19:40:12 -0400
X-Greylist: delayed 14376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2021 19:40:12 EDT
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
IronPort-SDR: Dns4G/r8N29QJwjarjn0HeFo3KWXqArtTO1m8zhLnoHvGNBMjnBqZAV9Zllfol2+IwSJKSQo17
 dsLgAFAQYdRA==
IronPort-PHdr: =?us-ascii?q?A9a23=3ANMcWmxRoJ4ABQKueMAMumimcMNpsol+ZAWYlg?=
 =?us-ascii?q?6HP6ppLe6WnuZbrP0XF+fwrg1iPXImIo+lchb/wtKbtEXcF/Y7HqGoLJYdBT?=
 =?us-ascii?q?FkDgMYbhRA6CcieIU/yL/fwcyV8E8MEVVM2t2qjPx1tFdz7SkfIpWf69jsOA?=
 =?us-ascii?q?lP6PAtxKP7yH9vJgt/x0emx9ofPeQxOnxK/aLB7Ngm/6wrW8Mga0sN5Mqhk7?=
 =?us-ascii?q?BzPrzNTfvhOg2NlIVXGhxHn+sK554Ju6QxCvu4o75QGU6z5dr4kRPpXC3InP?=
 =?us-ascii?q?wjZ/eXNsh/OBUuK73oYFGcfkRNSHwGD4xa8X5uj+i39/vFw3iWXJ4X/UKw0V?=
 =?us-ascii?q?DK+7qxqVA6N6m9PNjg393vSg9Bxi6QTqQyophh2yYrZKI+PM/82cqTYdNIcD?=
 =?us-ascii?q?W1PO6QZHzdMGcW6ZogCFfYbNOBDh4v0pFIUsRL4Cg7qBe+ugj5Ei3nq3LErh?=
 =?us-ascii?q?vw7GFKjvkRoFNYPvXLI6dTtYf5KF7noivKZi2WdPLtM1Dzw6ZbFaEUkqPCIG?=
 =?us-ascii?q?7B5csPL1UBpGASDj1nDzO6tdz6TyOkJtHCWquR6Uuf6wXUqsEd3qzui3Ns2g?=
 =?us-ascii?q?4/SroAcyVne6Sw/z4FzJNHyGysZKZa0VYBdsS2XLd48Wc45BWdhuysg1qcPv?=
 =?us-ascii?q?4WTfiEJwY47zljQbLqGf8Lbh3CrHPbUKjB+inV/fbu5jBvn6kmsxNr3Ucys2?=
 =?us-ascii?q?UpLpC5I+jXVnkgAzRn+8NKAULM9+06g3XCN3gPa8P1NZ08z06vXedYqy7g2k?=
 =?us-ascii?q?YZbukPZBCL9hEHn6c3ePkQi5uWy8/7qfv39q5mQOpU8gxziMqkohs20APgpe?=
 =?us-ascii?q?gkIUW+B/O2g1brltUPjR7ACgvozm6jf+JfUQKZT7rW0GElT24Uu8QqlBjG9+?=
 =?us-ascii?q?NYRnnAdMFsDdxXBjoSoc1DCLfbkDOuu1lGlkTNl3ffDbdiDSt3GKnnOlqukf?=
 =?us-ascii?q?K4oshYakVd1loEZt8wHQqsMK//yRELr4dnRDxt/MQW3yvz7AZNy0cUfVTHqY?=
 =?us-ascii?q?OfRPaXMvFuP/u9qLfOLYdpfozvmbf4s5PP0kWUwn0Q1f6Cq1IELYTa3GbJnL?=
 =?us-ascii?q?w/KBBikysdECmoMsgckGabxhUbEVzdQamyuRas6/Rk5AYGvF5vKAI+qxr2Nl?=
 =?us-ascii?q?nTefNUediVNDVaCFm3tfoOPVqIXaS6cFcRmlyQNSbmrT4JynQHrrgLxzKBra?=
 =?us-ascii?q?/bF4iBN/4y2z8B7vqeA8HN6vSwxFcmW1HuBCn15jn9dDSFjx7hx+AR0glKTm?=
 =?us-ascii?q?alg364BTYcVvasYFFh8bMW5raQyCtb5Xh/Nc4W+U06oBNqhBj41Q5Q6xNpGY?=
 =?us-ascii?q?kB2H8iug0L0xDKkRboclrjNFZU09aWa1H/0QqQ1g3fA3608g1R0WdNBc3ajm?=
 =?us-ascii?q?rZ++07RDo3AiVmQ0amtM6UQlDjE8GPJpYaXlGdfVgM4EaDMXHRZZELVpM7l7?=
 =?us-ascii?q?wXNSPmvBeZvNAwJ0sOEJqZQItT0kVVLQuviM9XCcgfT0y+xAxiP3LaFcIvtf?=
 =?us-ascii?q?S0UwizcDEEOlw1b82yBMEAyASKoomSWCzILdxqne0T37ex3s2+2VGcmyh2Dd?=
 =?us-ascii?q?xcn1bO28wQJjLqTTLUS0vNMuSssrSl1AEfo39/SDInlxUIpd6FdbNUhpVZfg?=
 =?us-ascii?q?DuB8VUgeMfxafA81RYEfg96vl3jzUByA4RE18ojr3ow0AM0JqXe0V8SElHQl?=
 =?us-ascii?q?Z32JLDTLXH/uR61bKuDkErTy5CQ86QC8ugiolP4lAOgFUM473wh3N4T0nfWt?=
 =?us-ascii?q?fCoREICFIn8VEo67U0wv7bBfiw0/J/Zz1V+NLW9qmWE2dsqDfE5w1CveJFeP?=
 =?us-ascii?q?OnXcW26W91fDM+oJuswnlGvZR9RJ+Fe+pk/OMa+fueH0qqmVA6BtCCjkW1fu?=
 =?us-ascii?q?sZ/20GF7TZ1DOHPmZcJkanwNu6vVT7/hU29u4b4nsZFaWNKdoJQ4SrtB4dLe?=
 =?us-ascii?q?qQ0coFNCGv8faWK?=
IronPort-Data: =?us-ascii?q?A9a23=3AN6uSR62q/WY/LMXrqPbD5cp0kn2cJEfYwER7X?=
 =?us-ascii?q?KvMYLTBsI5bpz1UmjAWXT3VO/6KMGb1Kdpwbom18xlQ65WEz9IwGgs+3Hw8F?=
 =?us-ascii?q?HgiRegppzi6BhypY37NdJ2roHqKWKzyU/GYRCwPZiKa9kjF3oTJ9yEmjPjQH?=
 =?us-ascii?q?OqkUoYoBwgoLeNaYHZ54f5cs7Nh6mJYqYDR7zKl4bsekeWGULOW82Ic3lYv1?=
 =?us-ascii?q?k62gEgHUMIeGt8vlgdWifhj5DcynpSOZX4VDfnZw3DQGuG4EgMmLgpqIWzQw?=
 =?us-ascii?q?4/Xw/stIovNfrfTYEgWS6aIewqHiXNMR6HkjR8EpyBaPqQTbaJaMBoR0GTPz?=
 =?us-ascii?q?44ZJNZl7PRcTS8yM7aKnu0eXgNECSh4JoVE8bzOO2S298OUiUzKG5fp66w0X?=
 =?us-ascii?q?R5rYNNEkgpwKSQUnRACExgLYw+0mOWsxL6TVOR2h9YkKo/tMZ93kndt0T3UE?=
 =?us-ascii?q?944Tp3ZBabH/9lV2HE3nM8mNfDTfcdfcjdtawnaSwNONloLEpU42uyh7lH5f?=
 =?us-ascii?q?iFYpUiRrKw7+GPUyhds1LHxPfLLe9qBVN5IhEjerWXDl0z/DwsdMtHPkGKt7?=
 =?us-ascii?q?HO2ie7LnCS9WZ56PLu17fNxiQS72G0JBxwSVFz9oOXRokizR9JSMUgd/CY1q?=
 =?us-ascii?q?a8u6EGxT9ukdwO5unGFuh8bHdtMe8U85QaIzbHU/gmYLnYDQjdEYd0i8sQxA?=
 =?us-ascii?q?y4jvnePks/2AiZsqrCTVXuZ7Z+Kqj+7PCEUKSkJYmkWRGMt5dT5oogphxvnU?=
 =?us-ascii?q?NFiFKfzgMedMTf92TeLqiVj1p0Nis8P3uO15zjvhT+3vZGQFiYr4QTTVySr9?=
 =?us-ascii?q?GtRYoO+fICl71XA7v9OIa6HSViFtT4KgaC26u0SCJCO0iCMaPsKHbWgofifW?=
 =?us-ascii?q?BXajEBiBd8r8CWF5XmieYkW7isWDEFkKdoeeCftbVP7pwRQ4JYVPGfCRal6f?=
 =?us-ascii?q?YO2DcUC06/kF92jUP3IBvJIb59teQSH8CxqZU+4wXvrlA4nlqRXEZGWb8+gB?=
 =?us-ascii?q?F4EEqJjijGxQo8117IxxyM5lUvMTJT/xlKs1r/2THiYV7AyK1vXRv8w6KeN5?=
 =?us-ascii?q?g7S9r53McaNzxxEFuH3fCjb2ZEaK1kGKn99C4qeg8pabueHLyJ5EWcoB/jWh?=
 =?us-ascii?q?707E6Rjkr5c0P/V8XyhclBRzlPzgnqBJx/iQnZucrLkWs4uhW0yOyUgOlHu1?=
 =?us-ascii?q?WJLSYCi9rsYcpFxZ7Qi5cR8xPh9Q/4CPcuaatxJRy/c8nIYcIPysYF+XAuig?=
 =?us-ascii?q?wuCOC3jbiJXV5htXBfI85nqcw/r8SAICAKovM03r7qnkA3BKbIFSh95DcOQe?=
 =?us-ascii?q?v+1xVK7lWcUnut+WEyOLMM7UEPh65RtMSbrieIfPMgKIBnEwX2UzW6+BxoE4?=
 =?us-ascii?q?+DVp5Iu2MbAg6mIqIDvHfEWNkxXAy/W8fC9MSDb5EK8yIlJXOGPOz7HPEvy9?=
 =?us-ascii?q?bmjfvRO5+71NvQLm1EMvZAUO7Bm0aV44tz1qLZcwyx7FXPCY1OsTL16SlGA0?=
 =?us-ascii?q?NRFu7dR7qBQvwK6XUXJ9MMyEbOEJcbsFlhXPg0hZ+KP/e4dnDDe6vNzLl+Sz?=
 =?us-ascii?q?Cl64b+OV0MUJBCklyVbJbdyN8Ur248JvsML8Q2kkRdsN9eNji1Q+kyTJ3oJX?=
 =?us-ascii?q?6Ig8J8AaKfthxc30FZEYJf0FSbw6Z2IbJNCKCECJDKJmrvIjq9fy1bJd2c5P?=
 =?us-ascii?q?WfE2+NRgpNItgoi5FkPOV2Fk4TtmfYx1RFW9nI5VGx9yBhZ3vhofGNqMUBwL?=
 =?us-ascii?q?I2R9jFhiM9EGW62cylHCQOU4Fe3x1kAhn/xUECuX2DKKyszI46l+k0H/n8ac?=
 =?us-ascii?q?jFF/b2w12/jWDrte4f/xEMaX0N67fnqUfRu/wvLlMegWcqfd7E8bCWjhbWva?=
 =?us-ascii?q?GwU7RvgHc41rFLOo+Bm++E2Z7eTHSgdvaw/D4SG/asZVh3CL2sER+MJ1KUEA?=
 =?us-ascii?q?X7bYjKq0CKHJ0Gqd+tSKvaM/ULQI8pjIcRnSBm02C+Q6DcBCsYkJbJqnfot6?=
 =?us-ascii?q?fIdd7nlOHwHtL3ZpT1s2K88XACWaHQDUdBymN5nbIHYdDuYDmXWinwSmmOlk?=
 =?us-ascii?q?SWNAULgCfFsWeE29LrdHCQ1+5M/XCVEY0Qu26Pu+XecMwJ94xvSswSFZqO+I?=
 =?us-ascii?q?ymOD2hzt9OEL0mBL1zcxRDPuCCg8gmwus5SZJXANoHPu2v5b3H5ah9OM+J5t?=
 =?us-ascii?q?8tfy9ywXR2e4K8BlLQ/UGnDh5DHGK4P5MnasC+79C7oBCEyoBZugPPR3iY?=
 =?us-ascii?q?=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AkzvGvKvReWUnwBMGOOlHHNTQ7skDRNV00z?=
 =?us-ascii?q?EX/kB9WHVpm6uj5rmTdZUgpHnJYFR4Yh0dcLW7V5VoLkmslqKdjbNhX4tKPz?=
 =?us-ascii?q?OW31dATrsSiLcKqgeIc0aVm4886U4KSdkbNDSENykBsS+M2njELz9Z+qj9zE?=
 =?us-ascii?q?n+v5an856zd29XV50=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2HhXgDR+nph/1YnDwpaDw4BASsBCQE?=
 =?us-ascii?q?GAQUFASKBW4E6AgEBAQEBYGGBHwQ8C4Q9jUSDFQOBYIRMQIQ+AgECglOIT4Y?=
 =?us-ascii?q?KgXsBCgEBAQEBAQEBARsTHAQBAQMDgTKDSCWCMB8JA0cBAgQBARMBAQYBAQE?=
 =?us-ascii?q?BAQMDBAICgSCFaA2DU4EIAQEBAQEBAQEBAQEBAQEBAQEBARYCH1JHAQQEAS0?=
 =?us-ascii?q?dAQEnARARASICDRkCIzgHEDQBASSCGEcBgg0DCa1JG3qBMYEBgggBAQaCWYI?=
 =?us-ascii?q?5DYJACYEQKAMBAQEBAQGFdoN3hWKBEIFIA4VThTwUglGSO1SeZ4Fsig+SQ2g?=
 =?us-ascii?q?HKIMNmQ+Fby2DWZIVkTamRJEnhHyBClCBZ016gRcKZVxRFwIPlFyHWgJEaDg?=
 =?us-ascii?q?CBgEKAQEDCQGCOo4UgRCBEAE?=
X-IPAS-Result: =?us-ascii?q?A2HhXgDR+nph/1YnDwpaDw4BASsBCQEGAQUFASKBW4E6A?=
 =?us-ascii?q?gEBAQEBYGGBHwQ8C4Q9jUSDFQOBYIRMQIQ+AgECglOIT4YKgXsBCgEBAQEBA?=
 =?us-ascii?q?QEBARsTHAQBAQMDgTKDSCWCMB8JA0cBAgQBARMBAQYBAQEBAQMDBAICgSCFa?=
 =?us-ascii?q?A2DU4EIAQEBAQEBAQEBAQEBAQEBAQEBARYCH1JHAQQEAS0dAQEnARARASICD?=
 =?us-ascii?q?RkCIzgHEDQBASSCGEcBgg0DCa1JG3qBMYEBgggBAQaCWYI5DYJACYEQKAMBA?=
 =?us-ascii?q?QEBAQGFdoN3hWKBEIFIA4VThTwUglGSO1SeZ4Fsig+SQ2gHKIMNmQ+Fby2DW?=
 =?us-ascii?q?ZIVkTamRJEnhHyBClCBZ016gRcKZVxRFwIPlFyHWgJEaDgCBgEKAQEDCQGCO?=
 =?us-ascii?q?o4UgRCBEAE?=
X-IronPort-AV: E=Sophos;i="5.87,190,1631552400"; 
   d="scan'208";a="12975564"
Received: from zmtap2.jakarta.go.id ([10.15.39.86])
  by mail.jakarta.go.id with ESMTP; 29 Oct 2021 02:37:38 +0700
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id 6A2FF6276BA7;
        Fri, 29 Oct 2021 02:37:38 +0700 (WIB)
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id aitcJYbQ0DLt; Fri, 29 Oct 2021 02:37:38 +0700 (WIB)
Received: from localhost (localhost [127.0.0.1])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id 7AA276276BBB;
        Fri, 29 Oct 2021 02:37:36 +0700 (WIB)
DKIM-Filter: OpenDKIM Filter v2.10.3 zmtap2.jakarta.go.id 7AA276276BBB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jakarta.go.id;
        s=zimbra-mail; t=1635449856;
        bh=ket9wQGPBpEx6WIqdSy6e4jzznNT/FBCSFyZOTIJdlo=;
        h=Date:From:Message-ID:MIME-Version;
        b=HVBsvo5ryxsZSGmooWUXSX7TsSuTjgUXemX1l2w0ntnYc9QO3UadDTF7Lgbkh6D+h
         VMGBpj1q7AX01K1dptRYaprPgsrGntJ5WMMZh+n1NWbGRRcSnfqOPfm7EQzRmVwnzH
         tSU3dw09a1vgxIrAwAOaDT7fp4I9GhgqATbenhObY8/qlqr5TI8Ot9vuXKKl9gmmZD
         FA4AqNk5y9Pk0iTMWtQSlZucJVHiVX4dDboGzFCd/VL6jfLMZINpDnBK05P59bhwU9
         stqlwdxl/R8ceShNE+jS3cLvhiPytIB4WCLtxizQsuCUlCM6gG9VH1Sk7JL7Wwga4F
         +wYdXsvcNs8Ug==
X-Virus-Scanned: amavisd-new at 
Received: from zmtap2.jakarta.go.id ([127.0.0.1])
        by localhost (zmtap2.jakarta.go.id [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xcmTCmL74AGa; Fri, 29 Oct 2021 02:37:36 +0700 (WIB)
Received: from zmailbox1.jakarta.go.id (zmailbox1.jakarta.go.id [10.15.39.83])
        by zmtap2.jakarta.go.id (Postfix) with ESMTP id 603BF6276BA7;
        Fri, 29 Oct 2021 02:37:26 +0700 (WIB)
Date:   Fri, 29 Oct 2021 02:37:26 +0700 (WIB)
From:   LAPORTE Marie-Josepha <ses.nakertrans@jakarta.go.id>
Message-ID: <1640921700.468752.1635449846327.JavaMail.zimbra@jakarta.go.id>
Subject: =?utf-8?Q?Tr=C3=A8s_Urgent!?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.15.39.86]
X-Mailer: Zimbra 8.8.15_GA_4173 (zclient/8.8.15_GA_4173)
Thread-Index: NdP8aREgScHHTR0Ddja5vTEaDgLjuA==
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
