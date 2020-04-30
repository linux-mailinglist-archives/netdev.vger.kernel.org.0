Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007A01C0459
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgD3SGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 14:06:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3SGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 14:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588269991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3H+OFhUG8HCJy/9Jt3KcreVRkpStX8cTEw2GQonTOdw=;
        b=XyieN3O3lsf5kbYADVAHh8OaHrCwzLcP/XvlH14Qubz7szBNf3JaCMb6cpsDTEOZPwpg5N
        ESAiX1OCRXTBZjXwm7PEHhI3SIP+rDO+OYzErXfFtycCRHb168ejN03MNiaASgO1Hs6rYG
        iwbTJFPq68INrT/a3gMsprB74l/zHfc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-WWlNSiNOP2qBGa1eaSeDNg-1; Thu, 30 Apr 2020 14:06:29 -0400
X-MC-Unique: WWlNSiNOP2qBGa1eaSeDNg-1
Received: by mail-ed1-f69.google.com with SMTP id m5so2303576edv.8
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 11:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3H+OFhUG8HCJy/9Jt3KcreVRkpStX8cTEw2GQonTOdw=;
        b=cXGdraXTT8+mbCDr8c3HObOiKEbPv/YVuYJCkBpKLmiD5M172dQa1UWmSjlqX9VZp/
         s/X1JmKNaI/MTf9cS72aSbs49Q5vEboNqb/HOpa7PskQ7LnlD5/1Fjv+ZEnP0y9V27+B
         R6idxm+rF0GPD+cUwREQ8RlQGZLydvPoOOzzR1XVLPsPVyrjU2zG2YmKf4TMG/kiooba
         PyOdjphi2pb3YSvhtsJ7SMA2qOcnb1BhBIGV7/GmvAnwP+JQXhq43ns/oyb3ITX7nkWN
         /QErAilblb3QBjBRL3IwHGJEqfq/NY1Z1f93J0hQXNSyOK0tue+gqyAPXDXrUPiwvfO6
         0BFQ==
X-Gm-Message-State: AGi0PuZEWi/oMsIIcZUeN4JzLCyLGNYY9MlEBMyYLDeaMeKMsogKQ0oC
        2E202nis684L8Kmp1pufkPChCivI52cLDiGi3yuyKOho8WaCUXydyZvX25yPy706NKTV7xJVveu
        RjNITn7mYRS3cL8zG76ADDdloXbKc6h8w
X-Received: by 2002:a50:d7c7:: with SMTP id m7mr181248edj.101.1588269987551;
        Thu, 30 Apr 2020 11:06:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypIq30IPVsJQ5mkLKNTUxOlYPCLfckceGHCBSIBLhtDHb3kPB7iRAOWkgjVM2ZhqmHD014EOhBaMqN2jQ6SsvRg=
X-Received: by 2002:a50:d7c7:: with SMTP id m7mr181209edj.101.1588269987288;
 Thu, 30 Apr 2020 11:06:27 -0700 (PDT)
MIME-Version: 1.0
References: <0f53a3a2bf42de2ff399c8396c3d0bc76c8344ea.1588269623.git.dcaratti@redhat.com>
In-Reply-To: <0f53a3a2bf42de2ff399c8396c3d0bc76c8344ea.1588269623.git.dcaratti@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 30 Apr 2020 20:06:16 +0200
Message-ID: <CAPpH65wJPckjnuLhB+=x+9OxuSecdFwz7cCkMYVg7AAbXTH08Q@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2] tc: full JSON support for 'bpf' filter
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 8:03 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> example using eBPF:
>
>  # tc filter add dev dummy0 ingress bpf \
>  > direct-action obj ./bpf/filter.o sec tc-ingress
>  # tc  -j filter show dev dummy0 ingress | jq
>  [
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0
>    },
>    {
>      "protocol": "all",
>      "pref": 49152,
>      "kind": "bpf",
>      "chain": 0,
>      "options": {
>        "handle": "0x1",
>        "bpf_name": "filter.o:[tc-ingress]",
>        "direct-action": true,
>        "not_in_hw": true,
>        "prog": {
>          "id": 101,
>          "tag": "a04f5eef06a7f555",
>          "jited": 1
>        }
>      }
>    }
>  ]
>
> v2:
>  - use print_nl(), thanks to Andrea Claudi
>  - use print_0xhex() for filter handle, thanks to Stephen Hemminger
>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  tc/f_bpf.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/tc/f_bpf.c b/tc/f_bpf.c
> index 135271aa1697..fa3552aefffd 100644
> --- a/tc/f_bpf.c
> +++ b/tc/f_bpf.c
> @@ -203,22 +203,24 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>         parse_rtattr_nested(tb, TCA_BPF_MAX, opt);
>
>         if (handle)
> -               fprintf(f, "handle 0x%x ", handle);
> +               print_0xhex(PRINT_ANY, "handle", "handle %#llx ", handle);
>
>         if (tb[TCA_BPF_CLASSID]) {
>                 SPRINT_BUF(b1);
> -               fprintf(f, "flowid %s ",
> +               print_string(PRINT_ANY, "flowid", "flowid %s ",
>                         sprint_tc_classid(rta_getattr_u32(tb[TCA_BPF_CLASSID]), b1));
>         }
>
>         if (tb[TCA_BPF_NAME])
> -               fprintf(f, "%s ", rta_getattr_str(tb[TCA_BPF_NAME]));
> +               print_string(PRINT_ANY, "bpf_name", "%s ",
> +                            rta_getattr_str(tb[TCA_BPF_NAME]));
>
>         if (tb[TCA_BPF_FLAGS]) {
>                 unsigned int flags = rta_getattr_u32(tb[TCA_BPF_FLAGS]);
>
>                 if (flags & TCA_BPF_FLAG_ACT_DIRECT)
> -                       fprintf(f, "direct-action ");
> +                       print_bool(PRINT_ANY,
> +                                  "direct-action", "direct-action ", true);
>         }
>
>         if (tb[TCA_BPF_FLAGS_GEN]) {
> @@ -226,14 +228,14 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>                         rta_getattr_u32(tb[TCA_BPF_FLAGS_GEN]);
>
>                 if (flags & TCA_CLS_FLAGS_SKIP_HW)
> -                       fprintf(f, "skip_hw ");
> +                       print_bool(PRINT_ANY, "skip_hw", "skip_hw ", true);
>                 if (flags & TCA_CLS_FLAGS_SKIP_SW)
> -                       fprintf(f, "skip_sw ");
> -
> +                       print_bool(PRINT_ANY, "skip_sw", "skip_sw ", true);
>                 if (flags & TCA_CLS_FLAGS_IN_HW)
> -                       fprintf(f, "in_hw ");
> +                       print_bool(PRINT_ANY, "in_hw", "in_hw ", true);
>                 else if (flags & TCA_CLS_FLAGS_NOT_IN_HW)
> -                       fprintf(f, "not_in_hw ");
> +                       print_bool(PRINT_ANY,
> +                                  "not_in_hw", "not_in_hw ", true);
>         }
>
>         if (tb[TCA_BPF_OPS] && tb[TCA_BPF_OPS_LEN])
> @@ -245,14 +247,13 @@ static int bpf_print_opt(struct filter_util *qu, FILE *f,
>         if (!dump_ok && tb[TCA_BPF_TAG]) {
>                 SPRINT_BUF(b);
>
> -               fprintf(f, "tag %s ",
> -                       hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
> -                                     RTA_PAYLOAD(tb[TCA_BPF_TAG]),
> -                                     b, sizeof(b)));
> +               print_string(PRINT_ANY, "tag", "tag %s ",
> +                            hexstring_n2a(RTA_DATA(tb[TCA_BPF_TAG]),
> +                            RTA_PAYLOAD(tb[TCA_BPF_TAG]), b, sizeof(b)));
>         }
>
>         if (tb[TCA_BPF_POLICE]) {
> -               fprintf(f, "\n");
> +               print_nl();
>                 tc_print_police(f, tb[TCA_BPF_POLICE]);
>         }
>
> --
> 2.26.2
>

LGTM.
Acked-by: Andrea Claudi <aclaudi@redhat.com>

