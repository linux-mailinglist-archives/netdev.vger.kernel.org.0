Return-Path: <netdev+bounces-6721-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D227179BB
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C22882813AD
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA409BE52;
	Wed, 31 May 2023 08:14:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E5DBA52
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:14:56 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2110C5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685520893; x=1717056893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A7FLB/m/yNzfNR2rBTeRYdMrluPgEWmMsHTKsrep9Jo=;
  b=tm4IfSdOfjc4wkvg03z5ah8W2Pwxu+ha6fcthF7M05rg2SrzyWA0gvaM
   fyWtmJN85wTyD2peEV/w4imKyMDV/TEB2XhDZjn8o1utpAN86H7S2DQWj
   wgYT7+LWDpKllA/EBMOJr64GrE6oSRXou1lrWvOFXcWwFkhZfezN5k0tU
   k+7YQpg8qrdc0C8umLVKKNukSHoDRTi14UopApbVMuiRgrU8CBA3766oS
   mj9bceOoluQl/okOYmXFosWqe9Pjzu03X3+zUfPCOJTmYbUb5r7q/hP4j
   ysj87XqesAEX/2NsoHzzwrSlyeSs85FQ8gnOLMPDrALO2h4c/ACSZHDEH
   g==;
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="215577216"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 May 2023 01:14:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 31 May 2023 01:14:53 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Wed, 31 May 2023 01:14:52 -0700
Date: Wed, 31 May 2023 08:14:51 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Petr Machata <petrm@nvidia.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 5/8] dcb: rewr: add new dcb-rewr
 subcommand
Message-ID: <20230531081451.rjhc3ie2yb4iyxzr@DEN-LT-70577>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-5-9f38e688117e@microchip.com>
 <87sfbd4kfb.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87sfbd4kfb.fsf@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

 > Daniel Machon <daniel.machon@microchip.com> writes:
> 
> > Add a new subcommand 'rewr' for configuring the in-kernel DCB rewrite
> > table. The rewr-table of the kernel is similar to the APP-table, and so
> > is this new subcommand. Therefore, much of the existing bookkeeping code
> > from dcb-app, can be reused in the dcb-rewr implementation.
> >
> > Initially, only support for configuring PCP and DSCP-based rewrite has
> > been added.
> >
> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> 
> Looks good overall, barring the comment about dcb_app_parse_mapping_cb()
> that I made in the other patch, and a handful of nits below.
> 
> > ---
> >  dcb/Makefile   |   3 +-
> >  dcb/dcb.c      |   4 +-
> >  dcb/dcb.h      |  32 ++++++
> >  dcb/dcb_app.c  |  49 ++++----
> >  dcb/dcb_rewr.c | 355 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 416 insertions(+), 27 deletions(-)
> 
> > diff --git a/dcb/dcb.h b/dcb/dcb.h
> > index b3bc30cd02c5..092dc90e8358 100644
> > --- a/dcb/dcb.h
> > +++ b/dcb/dcb.h
> > @@ -54,6 +54,10 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
> >  void dcb_print_array_kw(const __u8 *array, size_t array_size,
> >                       const char *const kw[], size_t kw_size);
> >
> > +/* dcp_rewr.c */
> > +
> > +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
> > +
> >  /* dcb_app.c */
> >
> >  struct dcb_app_table {
> > @@ -70,8 +74,29 @@ struct dcb_app_parse_mapping {
> >       int err;
> >  };
> >
> > +#define DCB_APP_PCP_MAX 15
> 
> This should be removed from dcb_app.c as well.
> 
> > +#define DCB_APP_DSCP_MAX 63
> 
> DCB_APP_DSCP_MAX should be introduced in a separate patch together with
> the s/63/DCB_APP_DSCP_MAX/ of the existing code, instead of including it
> all here. It's a concern separate from the main topic of the patch.

Ack.

> 
> > +
> >  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> >
> > +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
> > +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> > +                 const struct dcb_app_table *tab,
> > +                 bool (*filter)(const struct dcb_app *));
> > +
> > +bool dcb_app_is_dscp(const struct dcb_app *app);
> > +bool dcb_app_is_pcp(const struct dcb_app *app);
> > +
> > +int dcb_app_print_pid_dscp(__u16 protocol);
> > +int dcb_app_print_pid_pcp(__u16 protocol);
> > +int dcb_app_print_pid_dec(__u16 protocol);
> > +void dcb_app_print_filtered(const struct dcb_app_table *tab,
> > +                         bool (*filter)(const struct dcb_app *),
> > +                         void (*print_pid_prio)(int (*print_pid)(__u16),
> > +                                                const struct dcb_app *),
> > +                         int (*print_pid)(__u16 protocol),
> > +                         const char *json_name, const char *fp_name);
> > +
> >  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> >  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> >  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> > @@ -80,11 +105,18 @@ bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> >  bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> >
> >  int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
> > +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b);
> > +void dcb_app_table_sort(struct dcb_app_table *tab);
> > +void dcb_app_table_fini(struct dcb_app_table *tab);
> > +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> > +                                const struct dcb_app_table *b);
> >  void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> >                                  const struct dcb_app_table *b,
> >                                  bool (*key_eq)(const struct dcb_app *aa,
> >                                                 const struct dcb_app *ab));
> >
> > +int dcb_app_parse_pcp(__u32 *key, const char *arg);
> > +int dcb_app_parse_dscp(__u32 *key, const char *arg);
> >  void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
> >
> >  /* dcb_apptrust.c */
> > diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> > index 97cba658aa6b..3cb1bb302ed6 100644
> > --- a/dcb/dcb_app.c
> > +++ b/dcb/dcb_app.c
> 
> > @@ -643,9 +642,9 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
> 
> > +static int dcb_cmd_rewr_replace(struct dcb *dcb, const char *dev, int argc,
> > +                             char **argv)
> > +{
> 
> [...]
> 
> > +}
> > +
> > +
> 
> Two blank lines.
> 
> > +static int dcb_cmd_rewr_show(struct dcb *dcb, const char *dev, int argc,
> > +                          char **argv)
> > +{

