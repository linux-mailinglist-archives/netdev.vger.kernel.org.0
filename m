Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E5B4DE366
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241077AbiCRVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbiCRVUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:20:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271D11F0C9F;
        Fri, 18 Mar 2022 14:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0B47B825BC;
        Fri, 18 Mar 2022 21:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D1CC340F6;
        Fri, 18 Mar 2022 21:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647638359;
        bh=9tuvgnia34L1XS4rl4416f2el/BaTA8mE5F1nqmABUE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nAu2ViPjmtfru6j4TxIRjFQxfUNnDf3aynoH0nOcx7tJ8BdJfgqRPJ2PHxnfvu6ck
         9+BIGdE01PylzmyWZVQXxh8GXHdC7NsxlVB2QNqZNvHbCutllkqU2thGM2Hvafwy33
         5kB9xu4fkrHds7luMx3Bkj6DKLt/IzBHFmcg0TNgczVXgdDimuxO5RPe10lNI733Zk
         UWwIrsmthHWA7b4SYBO6INS39LHxiwIw9ULWfQA1BhZEBlgnbngAkJgsqmu5Thn+T7
         OSMeiUwfrRGU8ppXfuX5otzdTdWSsHcAd3dQAyQQuf7fhRzPuCYpbPYQN8rJSUKynt
         A4bCjyZCswpMA==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-2db2add4516so104504187b3.1;
        Fri, 18 Mar 2022 14:19:19 -0700 (PDT)
X-Gm-Message-State: AOAM530Vz2h3MCVSlMmCjnO4NkiwKdkD/kyAHl4sDtc6qKbF0xhS4v1D
        v4XUJ74jvQED4yWMuXYwZ6spKxXU4Bk4SIuyqsA=
X-Google-Smtp-Source: ABdhPJz37hm7uFMyBniSh26oqQn3KIcdYmUGr128oXucI91E+Sjqx0HF42Men1l9k2IzYwwE1aUi6Lbp8+Y+xMBbY3w=
X-Received: by 2002:a81:79d5:0:b0:2e5:9d33:82ab with SMTP id
 u204-20020a8179d5000000b002e59d3382abmr13387727ywc.460.1647638358473; Fri, 18
 Mar 2022 14:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-13-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-13-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 14:19:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5K9cdKCAf8mBu6zV2BSXjqdsB3bZ5i60=vfnHrYbh6vQ@mail.gmail.com>
Message-ID: <CAPhsuW5K9cdKCAf8mBu6zV2BSXjqdsB3bZ5i60=vfnHrYbh6vQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 12/17] bpf/hid: add more HID helpers
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:18 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> When we process an incoming HID report, it is common to have to account
> for fields that are not aligned in the report. HID is using 2 helpers
> hid_field_extract() and implement() to pick up any data at any offset
> within the report.
>
> Export those 2 helpers in BPF programs so users can also rely on them.
> The second net worth advantage of those helpers is that now we can
> fetch data anywhere in the report without knowing at compile time the
> location of it. The boundary checks are done in hid-bpf.c, to prevent
> a memory leak.
>
> The third exported helper allows to communicate with the HID device.
> We give a data buffer, and call either HID_GET_REPORT or HID_SET_REPORT
> on the device.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v3:
> - renamed hid_{get|set}_data into hid_{get|set}_bits
> - squashed with bpf/hid: add bpf_hid_raw_request helper function
>
> changes in v2:
> - split the patch with libbpf and HID left outside.
> ---
>  include/linux/bpf-hid.h        |  6 +++
>  include/uapi/linux/bpf.h       | 36 +++++++++++++++++
>  kernel/bpf/hid.c               | 73 ++++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 36 +++++++++++++++++
>  4 files changed, 151 insertions(+)
>
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> index 7f596554fe8c..82b7466b5008 100644
> --- a/include/linux/bpf-hid.h
> +++ b/include/linux/bpf-hid.h
> @@ -102,6 +102,12 @@ struct bpf_hid_hooks {
>         int (*pre_link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
>         void (*post_link_attach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
>         void (*array_detach)(struct hid_device *hdev, enum bpf_hid_attach_type type);
> +       int (*hid_get_bits)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> +                           u64 offset, u32 n, u32 *data);
> +       int (*hid_set_bits)(struct hid_device *hdev, u8 *buf, size_t buf_size,
> +                           u64 offset, u32 n, u32 data);
> +       int (*hid_raw_request)(struct hid_device *hdev, u8 *buf, size_t size,
> +                              u8 rtype, u8 reqtype);
>  };
>
>  #ifdef CONFIG_BPF
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0e8438e93768..41ab1d068369 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5155,6 +5155,39 @@ union bpf_attr {
>   *             by a call to bpf_hid_discard;
>   *     Return
>   *             The pointer to the data. On error, a null value is returned.
> + *
> + * int bpf_hid_get_bits(void *ctx, u64 offset, u32 n, u32 *data)
> + *     Description
> + *             Get the data of size n (in bits) at the given offset (bits) in the
> + *             ctx->event.data field and store it into data.
> + *
> + *             n must be less or equal than 32, and we can address with bit
> + *             precision the value in the buffer. data must be a pointer
> + *             to a u32.
> + *     Return
> + *             The length of data copied into data. On error, a negative value
> + *             is returned.
> + *
> + * int bpf_hid_set_bits(void *ctx, u64 offset, u32 n, u32 data)
> + *     Description
> + *             Set the data of size n (in bits) at the given offset (bits) in the
> + *             ctx->event.data field.
> + *
> + *             n must be less or equal than 32, and we can address with bit
> + *             precision the value in the buffer.
> + *     Return
> + *             The length of data copied into ctx->event.data. On error, a negative
> + *             value is returned.
> + *
 Please use annotations like *offset*.

> + * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 report_type, u8 request_type)
> + *     Description
> + *             communicate with the HID device
> + *
> + *             report_type is one of HID_INPUT_REPORT, HID_OUTPUT_REPORT, HID_FEATURE_REPORT
> + *             request_type is one of HID_REQ_SET_REPORT or HID_REQ_GET_REPORT
> + *     Return
> + *             0 on success.
> + *             negative value on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5352,6 +5385,9 @@ union bpf_attr {
>         FN(skb_set_tstamp),             \
>         FN(ima_file_hash),              \
>         FN(hid_get_data),               \
> +       FN(hid_get_bits),               \
> +       FN(hid_set_bits),               \
> +       FN(hid_raw_request),            \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
> index 2dfeaaa8a83f..30a62e8e0f0a 100644
> --- a/kernel/bpf/hid.c
> +++ b/kernel/bpf/hid.c
> @@ -66,12 +66,85 @@ static const struct bpf_func_proto bpf_hid_get_data_proto = {
>         .arg3_type = ARG_CONST_ALLOC_SIZE_OR_ZERO,
>  };
>
> +BPF_CALL_4(bpf_hid_get_bits, struct hid_bpf_ctx_kern*, ctx, u64, offset, u32, n, u32*, data)
> +{
> +       if (!hid_hooks.hid_get_bits)
> +               return -EOPNOTSUPP;

Shall we also check offset and n are valid here?

> +
> +       return hid_hooks.hid_get_bits(ctx->hdev,
> +                                     ctx->data,
> +                                     ctx->allocated_size,
> +                                     offset, n,
> +                                     data);
> +}
> +
> +static const struct bpf_func_proto bpf_hid_get_bits_proto = {
> +       .func      = bpf_hid_get_bits,
> +       .gpl_only  = true,
> +       .ret_type  = RET_INTEGER,
> +       .arg1_type = ARG_PTR_TO_CTX,
> +       .arg2_type = ARG_ANYTHING,
> +       .arg3_type = ARG_ANYTHING,
> +       .arg4_type = ARG_PTR_TO_INT,
> +};
> +
> +BPF_CALL_4(bpf_hid_set_bits, struct hid_bpf_ctx_kern*, ctx, u64, offset, u32, n, u32, data)
> +{
> +       if (!hid_hooks.hid_set_bits)
> +               return -EOPNOTSUPP;
> +
> +       hid_hooks.hid_set_bits(ctx->hdev,
> +                              ctx->data,
> +                              ctx->allocated_size,
> +                              offset, n,
> +                              data);
> +       return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_hid_set_bits_proto = {
> +       .func      = bpf_hid_set_bits,
> +       .gpl_only  = true,
> +       .ret_type  = RET_INTEGER,
> +       .arg1_type = ARG_PTR_TO_CTX,
> +       .arg2_type = ARG_ANYTHING,
> +       .arg3_type = ARG_ANYTHING,
> +       .arg4_type = ARG_ANYTHING,
> +};
> +
> +BPF_CALL_5(bpf_hid_raw_request, struct hid_bpf_ctx_kern*, ctx, void*, buf, u64, size,
> +          u8, report_type, u8, request_type)
> +{
> +       if (!hid_hooks.hid_raw_request)
> +               return -EOPNOTSUPP;
> +
> +       return hid_hooks.hid_raw_request(ctx->hdev, buf, size, report_type, request_type);
> +}
> +
> +static const struct bpf_func_proto bpf_hid_raw_request_proto = {
> +       .func      = bpf_hid_raw_request,
> +       .gpl_only  = true, /* hid_raw_request is EXPORT_SYMBOL_GPL */
> +       .ret_type  = RET_INTEGER,
> +       .arg1_type = ARG_PTR_TO_CTX,
> +       .arg2_type = ARG_PTR_TO_MEM,
> +       .arg3_type = ARG_CONST_SIZE_OR_ZERO,
> +       .arg4_type = ARG_ANYTHING,
> +       .arg5_type = ARG_ANYTHING,
> +};
> +
>  static const struct bpf_func_proto *
>  hid_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
>         switch (func_id) {
>         case BPF_FUNC_hid_get_data:
>                 return &bpf_hid_get_data_proto;
> +       case BPF_FUNC_hid_get_bits:
> +               return &bpf_hid_get_bits_proto;
> +       case BPF_FUNC_hid_set_bits:
> +               return &bpf_hid_set_bits_proto;
> +       case BPF_FUNC_hid_raw_request:
> +               if (prog->expected_attach_type != BPF_HID_DEVICE_EVENT)
> +                       return &bpf_hid_raw_request_proto;
> +               return NULL;
>         default:
>                 return bpf_base_func_proto(func_id);
>         }
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 0e8438e93768..41ab1d068369 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5155,6 +5155,39 @@ union bpf_attr {
>   *             by a call to bpf_hid_discard;
>   *     Return
>   *             The pointer to the data. On error, a null value is returned.
> + *
> + * int bpf_hid_get_bits(void *ctx, u64 offset, u32 n, u32 *data)
> + *     Description
> + *             Get the data of size n (in bits) at the given offset (bits) in the
> + *             ctx->event.data field and store it into data.
> + *
> + *             n must be less or equal than 32, and we can address with bit
> + *             precision the value in the buffer. data must be a pointer
> + *             to a u32.
> + *     Return
> + *             The length of data copied into data. On error, a negative value
> + *             is returned.
> + *
> + * int bpf_hid_set_bits(void *ctx, u64 offset, u32 n, u32 data)
> + *     Description
> + *             Set the data of size n (in bits) at the given offset (bits) in the
> + *             ctx->event.data field.
> + *
> + *             n must be less or equal than 32, and we can address with bit
> + *             precision the value in the buffer.
> + *     Return
> + *             The length of data copied into ctx->event.data. On error, a negative
> + *             value is returned.
> + *
> + * int bpf_hid_raw_request(void *ctx, void *buf, u64 size, u8 report_type, u8 request_type)
> + *     Description
> + *             communicate with the HID device
> + *
> + *             report_type is one of HID_INPUT_REPORT, HID_OUTPUT_REPORT, HID_FEATURE_REPORT
> + *             request_type is one of HID_REQ_SET_REPORT or HID_REQ_GET_REPORT
> + *     Return
> + *             0 on success.
> + *             negative value on error.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -5352,6 +5385,9 @@ union bpf_attr {
>         FN(skb_set_tstamp),             \
>         FN(ima_file_hash),              \
>         FN(hid_get_data),               \
> +       FN(hid_get_bits),               \
> +       FN(hid_set_bits),               \
> +       FN(hid_raw_request),            \
>         /* */
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> --
> 2.35.1
>
