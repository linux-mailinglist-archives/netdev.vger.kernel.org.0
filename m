Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8087A58F763
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiHKFsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKFsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:48:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4579D8A6E7;
        Wed, 10 Aug 2022 22:48:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id g13so9185385plo.6;
        Wed, 10 Aug 2022 22:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=lGZpvi+V7uVfiXAxehiccE20rUObN6czoIhv/ReYg+U=;
        b=cxCpIhzVHdr2SxQ5Z9+a19Ap2LKLfRXqLW+jpl6Zzv2QSa/KvH5GzYFrxQgQsznvPH
         eDtlHLVDldGYHShCjHOIv3cFtzRmuKh8xQfz2vlAv8zO73R6BmH4ayfMR/BDHYWnSfUL
         ECjGiEfxSSaVBBahJi1xfzXCguFtjD5O8fkSDbHwmB0IoyPKu9JZdXGGrFYhmmeqBIBi
         Mz9Tfsvycgd7HOJq/BC2wVfgQuIn/owseei6AMtWSjRPRlNa4SnJACpK3ZdLfla03o7g
         77qIJ49XvAC4A0ZUK8Nyg9QZtYOxDzPSiqsBGp6wJD9t43vTd0sGogWrIcS/JfrEbSq3
         aWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=lGZpvi+V7uVfiXAxehiccE20rUObN6czoIhv/ReYg+U=;
        b=sWAyXeODx2ff8Gqbo3VmG1988nyif5ZbeIni4PiTkzFOJSg6Odq2JqA+ZnwBFmzDnX
         Cjk6LyofW0eAOb4JX7SIY0DHi4dVh29bBCNU64/C1RsMm5st8IuLN/9/E1cXzqAsKFe7
         WqWVYkqha0RJHsCcfIAbtVGzJqh9iY4KiCPFZG7FGwePifXIs1cG4dyWmarnbCwNoqem
         B3c19cHf0HXa/Ln7BnJ5e2NRv4ZYv2yesG1ZVLeK96qMXKM+obHyG5lFAtUoQocviNOc
         egyhC8tLbNOI9nlQ8nqV9Yd4YE22GFEUZUvyfur1AMD10WBvom7jYUQwrP+VUwR1EpUN
         b/gw==
X-Gm-Message-State: ACgBeo3Snvl2zqY1Cq9OmWCIFqo60ja0oLWBKwPhOMjT7rYLF2jhw0k1
        3NIE5rQI57m6VS4QCYyVCBc=
X-Google-Smtp-Source: AA6agR5LDoz9JH2qypquzw3PHjLTDc1B37XledaOyuiVcPkrjWMFZTMjcdxyllkx4izE83hB3aynaQ==
X-Received: by 2002:a17:903:120c:b0:170:aa42:dbba with SMTP id l12-20020a170903120c00b00170aa42dbbamr17174003plh.67.1660196931654;
        Wed, 10 Aug 2022 22:48:51 -0700 (PDT)
Received: from localhost ([2405:6580:97e0:3100:ae94:2ee7:59a:4846])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b0016c0b0fe1c6sm13910483plb.73.2022.08.10.22.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 22:48:51 -0700 (PDT)
Date:   Thu, 11 Aug 2022 14:48:49 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <YvSYQe58MwWh4x+q@d3>
References: <20220811022304.583300-1-kuba@kernel.org>
 <20220811022304.583300-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811022304.583300-4-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-10 19:23 -0700, Jakub Kicinski wrote:
> A very short and very incomplete generic python library.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/net/ynl/samples/ynl.py | 342 +++++++++++++++++++++++++++++++++++
>  1 file changed, 342 insertions(+)
>  create mode 100644 tools/net/ynl/samples/ynl.py
> 
> diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/samples/ynl.py
> new file mode 100644
> index 000000000000..59c178e063f1
> --- /dev/null
> +++ b/tools/net/ynl/samples/ynl.py
> @@ -0,0 +1,342 @@
[...]
> +class YnlFamily:
> +    def __init__(self, def_path, schema=None):
> +        with open(def_path, "r") as stream:
> +            self.yaml = yaml.safe_load(stream)
> +
> +        if schema:
> +            with open(os.path.dirname(os.path.dirname(file_name)) + '/schema.yaml', "r") as stream:
> +                schema = yaml.safe_load(stream)
> +
> +            jsonschema.validate(self.yaml, schema)
> +

The schema validation part was not working. I got it going with the
following changes. It then flags some problems in ethtool.yaml.

diff --git a/tools/net/ynl/samples/ethtool.py b/tools/net/ynl/samples/ethtool.py
index 63c8e29f8e5d..4c5a4629748d 100755
--- a/tools/net/ynl/samples/ethtool.py
+++ b/tools/net/ynl/samples/ethtool.py
@@ -14,7 +14,7 @@ def main():
     parser.add_argument('--ifindex', dest='ifindex', type=str)
     args = parser.parse_args()
 
-    ynl = YnlFamily(args.spec)
+    ynl = YnlFamily(args.spec, args.schema)
 
     if args.dev_name:
         channels = ynl.channels_get({'header': {'dev_name': args.dev_name}})
diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/samples/ynl.py
index 59c178e063f1..35c894b0ec19 100644
--- a/tools/net/ynl/samples/ynl.py
+++ b/tools/net/ynl/samples/ynl.py
@@ -247,7 +247,7 @@ class YnlFamily:
             self.yaml = yaml.safe_load(stream)
 
         if schema:
-            with open(os.path.dirname(os.path.dirname(file_name)) + '/schema.yaml', "r") as stream:
+            with open(schema, "r") as stream:
                 schema = yaml.safe_load(stream)
 
             jsonschema.validate(self.yaml, schema)
