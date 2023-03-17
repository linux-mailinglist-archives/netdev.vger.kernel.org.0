Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699316BF489
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCQVpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbjCQVpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:45:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A74CDE3;
        Fri, 17 Mar 2023 14:44:34 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so6655293pjp.1;
        Fri, 17 Mar 2023 14:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679089371;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFBF3aoCDzJCKnQzjtj3KAbX/g9gllas0cPUtC2AElQ=;
        b=LMrEWqiv3C7gLXyADrhik9HFsIhYpPv/LYsy1fmqAP9hZ51xxbCqwYCzZHKYx1oZh/
         AwA3fQnJ2w7Xz87OhMGbX/2RYdJEr4ynkfpk0t63yI9I46p8N5eZf7WTlr9mO8kxsrQu
         OPEP388AnRxhXkmbF579aYpdv4ZM/3xwZgEWGHydrLfWiX4v1ImV5TL95ovFnCItveXu
         fCzqtY+Tm1ZMhPWNWs1tiGuIQEf3N4nbLieKuB6MBGNRy7Wpefl67pH26abf20JAyll+
         USIRLQw7k+8fSFjZ0fwxhcE85QUUPA701EQyEzfnnHsfiCxpwXsSNH/fDOH5zi6rqwaA
         Xz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679089371;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFBF3aoCDzJCKnQzjtj3KAbX/g9gllas0cPUtC2AElQ=;
        b=IAOe5+6OSomfaPAnygCvffjZ/RHsRxxTyEU2Cogfq0joWLsE2m6QeMYvcWcRDipSuZ
         YvaOQEH2+cYgOAxIQ5h0G2pKreYbm2E4Ni9HqZafMq0aA98cH0JX8OwfqpFkLuLCmhOs
         Ewr1Be+ZJaRlGXFErvY0WzDcAoG+0YLyuPtNQM9UQMBk4UyRVP3KH7u9cXphmT8VEfRR
         qlek4wn5Rjj5cqpPrdXlg3aNyFkvBo3nYNNQaK4rEBrBU9AtxAwd5LuJ+w+rkbBw17k3
         qUnjQ7+cieQUub/Qa/h9hXdyMNsrm9Yb3COEBIqMoU6HXwdlvQJX8W23vozzLn5YArjL
         G0bg==
X-Gm-Message-State: AO0yUKX8vA4Y7tM8oaNqgOmAsT0/si3yHohnUp3nnC0OjqQ/lcF82VNv
        TJXm915jZx5pwHalUDuEWWI=
X-Google-Smtp-Source: AK7set99q623mA3d1B75yMKUz/qCoVth/TvmSwr2Q9soYaexsMOXl5Zb3TtEgkz566iV6nIXTOF0Dw==
X-Received: by 2002:a17:902:dccb:b0:1a1:b440:3773 with SMTP id t11-20020a170902dccb00b001a1b4403773mr491133pll.27.1679089371242;
        Fri, 17 Mar 2023 14:42:51 -0700 (PDT)
Received: from smtpclient.apple ([2601:1c0:4d7f:138e::3])
        by smtp.gmail.com with ESMTPSA id w15-20020a170902a70f00b0019a8468cbe7sm1963126plq.224.2023.03.17.14.42.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Mar 2023 14:42:50 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [RFC PATCH 2/9] iscsi: associate endpoints with a host
From:   Lee Duncan <leeman.duncan@gmail.com>
In-Reply-To: <a9f8cc4f-5d60-be5e-d294-c4a9baa16ec4@suse.de>
Date:   Fri, 17 Mar 2023 14:42:40 -0700
Cc:     linux-scsi@vger.kernel.org,
        open-iscsi <open-iscsi@googlegroups.com>, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C3D117B2-4FAE-44AB-851B-67C5C98B73CF@gmail.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
 <a9f8cc4f-5d60-be5e-d294-c4a9baa16ec4@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mar 14, 2023, at 9:23 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/8/23 18:40, Lee Duncan wrote:
>> From: Lee Duncan <lduncan@suse.com>
>> Right now the iscsi_endpoint is only linked to a connection once that
>> connection has been established.  For net namespace filtering of the
>> sysfs objects, associate an endpoint with the host that it was
>> allocated for when it is created.
>> Signed-off-by: Chris Leech <cleech@redhat.com>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>  drivers/infiniband/ulp/iser/iscsi_iser.c | 2 +-
>>  drivers/scsi/be2iscsi/be_iscsi.c         | 2 +-
>>  drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
>>  drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
>>  drivers/scsi/qedi/qedi_iscsi.c           | 2 +-
>>  drivers/scsi/qla4xxx/ql4_os.c            | 2 +-
>>  drivers/scsi/scsi_transport_iscsi.c      | 3 ++-
>>  include/scsi/scsi_transport_iscsi.h      | 6 +++++-
>>  8 files changed, 13 insertions(+), 8 deletions(-)
>> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c =
b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> index 620ae5b2d80d..d38c909b462f 100644
>> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
>> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
>> @@ -802,7 +802,7 @@ static struct iscsi_endpoint =
*iscsi_iser_ep_connect(struct Scsi_Host *shost,
>>  	struct iser_conn *iser_conn;
>>  	struct iscsi_endpoint *ep;
>>  -	ep =3D iscsi_create_endpoint(0);
>> +	ep =3D iscsi_create_endpoint(shost, 0);
>>  	if (!ep)
>>  		return ERR_PTR(-ENOMEM);
>>  diff --git a/drivers/scsi/be2iscsi/be_iscsi.c =
b/drivers/scsi/be2iscsi/be_iscsi.c
>> index 8aeaddc93b16..c893d193f5ef 100644
>> --- a/drivers/scsi/be2iscsi/be_iscsi.c
>> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
>> @@ -1168,7 +1168,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, =
struct sockaddr *dst_addr,
>>  		return ERR_PTR(ret);
>>  	}
>>  -	ep =3D iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
>> +	ep =3D iscsi_create_endpoint(shost, sizeof(struct =
beiscsi_endpoint));
>>  	if (!ep) {
>>  		ret =3D -ENOMEM;
>>  		return ERR_PTR(ret);
>> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c =
b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> index a3c800e04a2e..ac63e93e07c6 100644
>> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>> @@ -384,7 +384,7 @@ static struct iscsi_endpoint =
*bnx2i_alloc_ep(struct bnx2i_hba *hba)
>>  	struct bnx2i_endpoint *bnx2i_ep;
>>  	u32 ec_div;
>>  -	ep =3D iscsi_create_endpoint(sizeof(*bnx2i_ep));
>> +	ep =3D iscsi_create_endpoint(hba->shost, sizeof(*bnx2i_ep));
>>  	if (!ep) {
>>  		printk(KERN_ERR "bnx2i: Could not allocate ep\n");
>>  		return NULL;
>> diff --git a/drivers/scsi/cxgbi/libcxgbi.c =
b/drivers/scsi/cxgbi/libcxgbi.c
>> index af281e271f88..94edf8e1fb0c 100644
>> --- a/drivers/scsi/cxgbi/libcxgbi.c
>> +++ b/drivers/scsi/cxgbi/libcxgbi.c
>> @@ -2926,7 +2926,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct =
Scsi_Host *shost,
>>  		goto release_conn;
>>  	}
>>  -	ep =3D iscsi_create_endpoint(sizeof(*cep));
>> +	ep =3D iscsi_create_endpoint(shost, sizeof(*cep));
>>  	if (!ep) {
>>  		err =3D -ENOMEM;
>>  		pr_info("iscsi alloc ep, OOM.\n");
>> diff --git a/drivers/scsi/qedi/qedi_iscsi.c =
b/drivers/scsi/qedi/qedi_iscsi.c
>> index 31ec429104e2..4baf1dbb8e92 100644
>> --- a/drivers/scsi/qedi/qedi_iscsi.c
>> +++ b/drivers/scsi/qedi/qedi_iscsi.c
>> @@ -931,7 +931,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct =
sockaddr *dst_addr,
>>  		return ERR_PTR(-ENXIO);
>>  	}
>>  -	ep =3D iscsi_create_endpoint(sizeof(struct qedi_endpoint));
>> +	ep =3D iscsi_create_endpoint(shost, sizeof(struct =
qedi_endpoint));
>>  	if (!ep) {
>>  		QEDI_ERR(&qedi->dbg_ctx, "endpoint create fail\n");
>>  		ret =3D -ENOMEM;
>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c =
b/drivers/scsi/qla4xxx/ql4_os.c
>> index 005502125b27..acebf9c92c04 100644
>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>> @@ -1717,7 +1717,7 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, =
struct sockaddr *dst_addr,
>>  	}
>>    	ha =3D iscsi_host_priv(shost);
>> -	ep =3D iscsi_create_endpoint(sizeof(struct qla_endpoint));
>> +	ep =3D iscsi_create_endpoint(shost, sizeof(struct =
qla_endpoint));
>>  	if (!ep) {
>>  		ret =3D -ENOMEM;
>>  		return ERR_PTR(ret);
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c =
b/drivers/scsi/scsi_transport_iscsi.c
>> index be69cea9c6f8..86bafdb862a5 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -204,7 +204,7 @@ static struct attribute_group =
iscsi_endpoint_group =3D {
>>  };
>>    struct iscsi_endpoint *
>> -iscsi_create_endpoint(int dd_size)
>> +iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
>>  {
>>  	struct iscsi_endpoint *ep;
>>  	int err, id;
>> @@ -230,6 +230,7 @@ iscsi_create_endpoint(int dd_size)
>>    	ep->id =3D id;
>>  	ep->dev.class =3D &iscsi_endpoint_class;
>> +	ep->dev.parent =3D &shost->shost_gendev;
>>  	dev_set_name(&ep->dev, "ep-%d", id);
>>  	err =3D device_register(&ep->dev);
>>          if (err)
>=20
> Umm... doesn't this change the sysfs layout?
> IE won't the endpoint node be moved under the Scsi_Host directory?
>=20
> But even if it does: do we care?
>=20
>=20
> Cheers,
>=20
> Hannes
>=20

No, it=E2=80=99s still /sys/class/iscsi_endpoint, since the dev.class =
hasn=E2=80=99t changed.

=E2=80=94=20
Lee=
