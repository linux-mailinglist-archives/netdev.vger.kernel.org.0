Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310DC57D29E
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiGURcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiGURcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:32:24 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C912E680
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:32:22 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u14so2679007lju.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wx5J2diVr0NNIIYpiaHRCj+7276/V8VUtFQxjj6QDPQ=;
        b=Mjios/jp1I24lCzLEFKo9MyMe4Zaj4MBFlCIW6/8MigUTGDzrOaUd7wgCXFI7nmwwm
         yivCUlvblq8o6miv1hFworsanMXUbFbbUDzwdNX4pLeNj+QxiEX1lTFGBv4JYTkqJrfh
         3DweX1aT9wnr4BwKsznGzyzQZmDhV8CDKd91k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wx5J2diVr0NNIIYpiaHRCj+7276/V8VUtFQxjj6QDPQ=;
        b=699bOw7wwcC2Dee3QPWZ35Y4QiaXj52v+AcRRo0+PxC/GCVX87O03/p+WGT8USAWR9
         p766Y4GCcWeMkFyfL5N6TBGIN+tUVS7G5iXrhX3eb5uumskS95wg0Kxpm5+Y+aJpyail
         fdrqiJKl7/iClp9+8SEwz+14I1nSN8Xl6xkCodYkpn96B+fALxtEJD6gGlciibVQlg6C
         vwAdZSFGWFawEQi5BU4b4ypnNU2OJ2XecM5fFjoL/bktUpvdozVj2huIVZ2gdrf7vk2s
         +3GUYD8Ptm/sVXx39qmGiSoBbXtEfj7HEr868FdjmSUeDLyxQfopBUDTGzzRWy35dWf6
         ZT8A==
X-Gm-Message-State: AJIora+cwFyOsfNWTie2UkR+73Dr1UVKfeBRHJRDO/cxwXGT+laQeZQF
        Q30bZlifl5PmjBO6k1jLpXzjlOPmMG0LRFueTs56CA==
X-Google-Smtp-Source: AGRyM1u0Sd86qsycVJ8ENZEGoFwCSSeqy73etVcWimMo6b3ATexKJlv81AUl34U94RDZbSJQKmNEarNwyJdLc1wMMPk=
X-Received: by 2002:a2e:bf0e:0:b0:258:e99e:998c with SMTP id
 c14-20020a2ebf0e000000b00258e99e998cmr20099554ljr.365.1658424740139; Thu, 21
 Jul 2022 10:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com> <20220721072121.43648-2-vikas.gupta@broadcom.com>
 <YtlNGWp0D7M3PXvJ@nanopsycho>
In-Reply-To: <YtlNGWp0D7M3PXvJ@nanopsycho>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Thu, 21 Jul 2022 23:02:08 +0530
Message-ID: <CAHLZf_tMsZ-K70oUarNXYRnG10WyHNNVO2KpzECoFRy0C0dQpw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/3] devlink: introduce framework for selftests
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008b8fb905e4541986"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008b8fb905e4541986
Content-Type: text/plain; charset="UTF-8"

Hi Jiri,


On Thu, Jul 21, 2022 at 6:27 PM Jiri Pirko <jiri@nvidia.com> wrote:
>
> Thu, Jul 21, 2022 at 09:21:19AM CEST, vikas.gupta@broadcom.com wrote:
> >Add a framework for running selftests.
> >Framework exposes devlink commands and test suite(s) to the user
> >to execute and query the supported tests by the driver.
> >
> >Below are new entries in devlink_nl_ops
> >devlink_nl_cmd_selftests_list_doit/dumpit: To query the supported
> >selftests by the drivers.
> >devlink_nl_cmd_selftests_run: To execute selftests. Users can
> >provide a test mask for executing group tests or standalone tests.
> >
> >Documentation/networking/devlink/ path is already part of MAINTAINERS &
> >the new files come under this path. Hence no update needed to the
> >MAINTAINERS
> >
> >Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> >Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> >---
> > .../networking/devlink/devlink-selftests.rst  |  38 +++
> > include/net/devlink.h                         |  20 ++
> > include/uapi/linux/devlink.h                  |  29 +++
> > net/core/devlink.c                            | 225 ++++++++++++++++++
> > 4 files changed, 312 insertions(+)
> > create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
> >
> >diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
> >new file mode 100644
> >index 000000000000..0e9727895987
> >--- /dev/null
> >+++ b/Documentation/networking/devlink/devlink-selftests.rst
> >@@ -0,0 +1,38 @@
> >+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >+
> >+=================
> >+Devlink Selftests
> >+=================
> >+
> >+The ``devlink-selftests`` API allows executing selftests on the device.
> >+
> >+Tests Mask
> >+==========
> >+The ``devlink-selftests`` command should be run with a mask indicating
> >+the tests to be executed.
> >+
> >+Tests Description
> >+=================
> >+The following is a list of tests that drivers may execute.
> >+
> >+.. list-table:: List of tests
> >+   :widths: 5 90
> >+
> >+   * - Name
> >+     - Description
> >+   * - ``DEVLINK_SELFTEST_FLASH``
> >+     - Devices may have the firmware on non-volatile memory on the board, e.g.
> >+       flash. This particular test helps to run a flash selftest on the device.
> >+       Implementation of the test is left to the driver/firmware.
> >+
> >+example usage
> >+-------------
> >+
> >+.. code:: shell
> >+
> >+    # Query selftests supported on the devlink device
> >+    $ devlink dev selftests show DEV
> >+    # Query selftests supported on all devlink devices
> >+    $ devlink dev selftests show
> >+    # Executes selftests on the device
> >+    $ devlink dev selftests run DEV test flash
>
> "test_id" to be consistend with the attr name and outputs. Please see
What is "test_id" referring to in this document? Can you please elaborate ?

> below. Devlink cmdline would accept "test" as well, so you can still use
Are you mentioning the "test" argument in the above devlink command line option?

Thanks,
Vikas
> this.

>
>
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index 88c701b375a2..085d761f1cd3 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -1509,6 +1509,26 @@ struct devlink_ops {
> >                                   struct devlink_rate *parent,
> >                                   void *priv_child, void *priv_parent,
> >                                   struct netlink_ext_ack *extack);
> >+      /**
> >+       * selftests_check() - queries if selftest is supported
> >+       * @devlink: Devlink instance
>
> Why capital "D"?
>
>
> >+       * @test_id: test index
> >+       * @extack: extack for reporting error messages
> >+       *
> >+       * Return: true if test is supported by the driver
> >+       */
> >+      bool (*selftest_check)(struct devlink *devlink, int test_id,
>
> Why this is an "int". I would be surprised to see a negative value here.
> Have this unsigned please.
>
>
> >+                             struct netlink_ext_ack *extack);
> >+      /**
> >+       * selftest_run() - Runs a selftest
> >+       * @devlink: Devlink instance
> >+       * @test_id: test index
> >+       * @extack: extack for reporting error messages
> >+       *
> >+       * Return: Result of the test
> >+       */
> >+      u8 (*selftest_run)(struct devlink *devlink, int test_id,
>
> There too.
>
>
> >+                         struct netlink_ext_ack *extack);
> > };
> >
> > void *devlink_priv(struct devlink *devlink);
> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >index b3d40a5d72ff..469846f40e6d 100644
> >--- a/include/uapi/linux/devlink.h
> >+++ b/include/uapi/linux/devlink.h
> >@@ -136,6 +136,9 @@ enum devlink_command {
> >       DEVLINK_CMD_LINECARD_NEW,
> >       DEVLINK_CMD_LINECARD_DEL,
> >
> >+      DEVLINK_CMD_SELFTESTS_LIST,     /* can dump */
>
> The rest of the commands are named "_GET". Please be consistent with
> them.
>
>
> >+      DEVLINK_CMD_SELFTESTS_RUN,
> >+
> >       /* add new commands above here */
> >       __DEVLINK_CMD_MAX,
> >       DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
> >@@ -276,6 +279,31 @@ enum {
> > #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> >       (_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> >
> >+/* Commonly used test cases */
>
> What do you mean by "commonly". Are there some others that are not
> "common"? I don't follow.
>
>
> >+enum devlink_selftest_attr {
> >+      DEVLINK_SELFTEST_ATTR_UNSPEC,
> >+      DEVLINK_SELFTEST_ATTR_FLASH,            /* flag */
> >+
> >+      __DEVLINK_SELFTEST_ATTR_MAX,
> >+      DEVLINK_SELFTEST_ATTR_MAX = __DEVLINK_SELFTEST_ATTR_MAX - 1
> >+};
>
> To be consistent with the attr that caries this:
>
> enum devlink_attr_selftest_test_id {
>         DEVLINK_ATTR_SELFTEST_TEST_ID_UNSPEC,
>         DEVLINK_ATTR_SELFTEST_TEST_ID_FLASH,            /* flag */
>
>         __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX,
>         DEVLINK_ATTR_SELFTEST_TEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX - 1
>
> >+
> >+enum devlink_selftest_result {
> >+      DEVLINK_SELFTEST_SKIP,
> >+      DEVLINK_SELFTEST_PASS,
> >+      DEVLINK_SELFTEST_FAIL
>
> It is common to have the enum name be root of names of the values.
> Also, be consistent with the attr this value is carried over:
>
> enum devlink_selftest_test_status {
>         DEVLINK_SELFTEST_TEST_STATUS_SKIP,
>         DEVLINK_SELFTEST_TEST_STATUS_PASS,
>         DEVLINK_SELFTEST_TEST_STATUS_FAIL
>
> That way, it is obvious to which enum the value belongs.
>
>
> >+};
> >+
> >+enum devlink_selftest_result_attr {
> >+      DEVLINK_SELFTEST_ATTR_RESULT_UNSPEC,
> >+      DEVLINK_SELFTEST_ATTR_RESULT,           /* nested */
> >+      DEVLINK_SELFTEST_ATTR_TEST_ID,          /* u32, devlink_selftest_attr */
>
> add "enum" ?
>
> >+      DEVLINK_SELFTEST_ATTR_TEST_STATUS,      /* u8, devlink_selftest_result */
>
> add "enum" ?
>
> The same note as above:
> enum devlink_attr_selftest_result {
>         DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
>         DEVLINK_ATTR_SELFTEST_RESULT,             /* nested */
>         DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID,     /* u32, enum devlink_selftest_attr */
>         DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS, /* u8, devlink_selftest_result */
>
>
>
>
> >+
> >+      __DEVLINK_SELFTEST_ATTR_RES_MAX,
> >+      DEVLINK_SELFTEST_ATTR_RES_MAX = __DEVLINK_SELFTEST_ATTR_RES_MAX - 1
> >+};
> >+
> > /**
> >  * enum devlink_trap_action - Packet trap action.
> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
> >@@ -576,6 +604,7 @@ enum devlink_attr {
> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
> >
> >+      DEVLINK_ATTR_SELFTESTS_INFO,            /* nested */
> >       /* add new attributes above here, update the policy in devlink.c */
> >
> >       __DEVLINK_ATTR_MAX,
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index a9776ea923ae..ef9439f2502f 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -198,6 +198,10 @@ static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_
> >                                DEVLINK_PORT_FN_STATE_ACTIVE),
> > };
> >
> >+static const struct nla_policy devlink_selftest_nl_policy[DEVLINK_SELFTEST_ATTR_MAX + 1] = {
> >+      [DEVLINK_SELFTEST_ATTR_FLASH] = { .type = NLA_FLAG },
> >+};
> >+
> > static DEFINE_XARRAY_FLAGS(devlinks, XA_FLAGS_ALLOC);
> > #define DEVLINK_REGISTERED XA_MARK_1
> >
> >@@ -4791,6 +4795,215 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> >       return ret;
> > }
> >
> >+static int
> >+devlink_nl_selftests_fill(struct sk_buff *msg, struct devlink *devlink,
> >+                        u32 portid, u32 seq, int flags,
> >+                        struct netlink_ext_ack *extack)
> >+{
> >+      struct nlattr *selftests_list;
> >+      void *hdr;
> >+      int err;
> >+      int i;
> >+
> >+      hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags,
> >+                        DEVLINK_CMD_SELFTESTS_LIST);
> >+      if (!hdr)
> >+              return -EMSGSIZE;
> >+
> >+      err = -EMSGSIZE;
> >+      if (devlink_nl_put_handle(msg, devlink))
> >+              goto err_cancel_msg;
> >+
> >+      selftests_list = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
> >+      if (!selftests_list)
> >+              goto err_cancel_msg;
> >+
> >+      for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
>
> **)
> It is a bit odd to see "1" here. Maybe "DEVLINK_SELFTEST_ATTR_UNSPEC + 1"
> would be more obvious for the reader.
>
> also:
> i < DEVLINK_SELFTEST_ATTR_MAX + 1
> would be rather nicer to be:
> i <= DEVLINK_SELFTEST_ATTR_MAX
>
>
> >+              if (devlink->ops->selftest_check(devlink, i, extack)) {
> >+                      err = nla_put_flag(msg, i);
> >+                      if (err)
> >+                              goto err_cancel_msg;
> >+              }
> >+      }
> >+
> >+      nla_nest_end(msg, selftests_list);
> >+
>
> No need for this empty line.
>
>
> >+      genlmsg_end(msg, hdr);
> >+
>
> No need for this empty line.
>
>
> >+      return 0;
> >+
> >+err_cancel_msg:
> >+      genlmsg_cancel(msg, hdr);
> >+      return err;
> >+}
> >+
> >+static int devlink_nl_cmd_selftests_list_doit(struct sk_buff *skb,
> >+                                            struct genl_info *info)
> >+{
> >+      struct devlink *devlink = info->user_ptr[0];
> >+      struct sk_buff *msg;
> >+      int err;
> >+
> >+      if (!devlink->ops->selftest_check)
> >+              return -EOPNOTSUPP;
> >+
> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >+      if (!msg)
> >+              return -ENOMEM;
> >+
> >+      err = devlink_nl_selftests_fill(msg, devlink, info->snd_portid,
> >+                                      info->snd_seq, 0, info->extack);
> >+      if (err) {
> >+              nlmsg_free(msg);
> >+              return err;
> >+      }
> >+
> >+      return genlmsg_reply(msg, info);
> >+}
> >+
> >+static int devlink_nl_cmd_selftests_list_dumpit(struct sk_buff *msg,
> >+                                              struct netlink_callback *cb)
> >+{
> >+      struct devlink *devlink;
> >+      int start = cb->args[0];
> >+      unsigned long index;
> >+      int idx = 0;
> >+      int err = 0;
> >+
> >+      mutex_lock(&devlink_mutex);
> >+      xa_for_each_marked(&devlinks, index, devlink, DEVLINK_REGISTERED) {
> >+              if (!devlink_try_get(devlink))
> >+                      continue;
> >+
> >+              if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
> >+                      goto retry;
> >+
> >+              if (idx < start || !devlink->ops->selftest_check)
> >+                      goto inc;
> >+
> >+              mutex_lock(&devlink->lock);
> >+              err = devlink_nl_selftests_fill(msg, devlink,
> >+                                              NETLINK_CB(cb->skb).portid,
> >+                                              cb->nlh->nlmsg_seq, NLM_F_MULTI,
> >+                                              cb->extack);
> >+              mutex_unlock(&devlink->lock);
> >+              if (err) {
> >+                      devlink_put(devlink);
> >+                      break;
> >+              }
> >+inc:
> >+              idx++;
> >+retry:
> >+              devlink_put(devlink);
> >+      }
> >+      mutex_unlock(&devlink_mutex);
> >+
> >+      if (err != -EMSGSIZE)
> >+              return err;
> >+
> >+      cb->args[0] = idx;
> >+      return msg->len;
> >+}
> >+
> >+static int devlink_selftest_result_put(struct sk_buff *skb, int test_id,
>
> unsigned.
>
> >+                                     u8 result)
>
> Please be consistend and call this "test_status"
>
>
> >+{
> >+      struct nlattr *result_attr;
> >+
> >+      result_attr = nla_nest_start(skb, DEVLINK_SELFTEST_ATTR_RESULT);
> >+      if (!result_attr)
> >+              return -EMSGSIZE;
> >+
> >+      if (nla_put_u32(skb, DEVLINK_SELFTEST_ATTR_TEST_ID, test_id) ||
> >+          nla_put_u8(skb, DEVLINK_SELFTEST_ATTR_TEST_STATUS, result))
> >+              goto nla_put_failure;
> >+
> >+      nla_nest_end(skb, result_attr);
> >+
>
> No need for this empty line.
>
>
> >+      return 0;
> >+
> >+nla_put_failure:
> >+      nla_nest_cancel(skb, result_attr);
> >+      return -EMSGSIZE;
> >+}
> >+
> >+static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
> >+                                      struct genl_info *info)
> >+{
> >+      struct nlattr *tb[DEVLINK_SELFTEST_ATTR_MAX + 1];
> >+      struct devlink *devlink = info->user_ptr[0];
> >+      struct nlattr *attrs, *tests_info;
> >+      struct sk_buff *msg;
> >+      void *hdr;
> >+      int err;
> >+      int i;
> >+
> >+      if (!devlink->ops->selftest_run)
> >+              return -EOPNOTSUPP;
> >+
> >+      if (!info->attrs[DEVLINK_ATTR_SELFTESTS_INFO])
>
> Fill extack message here please.
>
>
> >+              return -EINVAL;
> >+
> >+      attrs = info->attrs[DEVLINK_ATTR_SELFTESTS_INFO];
> >+
> >+      err = nla_parse_nested(tb, DEVLINK_SELFTEST_ATTR_MAX, attrs,
> >+                             devlink_selftest_nl_policy, info->extack);
> >+      if (err < 0)
> >+              return err;
> >+
> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >+      if (!msg)
> >+              return -ENOMEM;
> >+
> >+      err = -EMSGSIZE;
> >+      hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> >+                        &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
> >+      if (!hdr)
> >+              goto free_msg;
> >+
> >+      if (devlink_nl_put_handle(msg, devlink))
> >+              goto genlmsg_cancel;
> >+
> >+      tests_info = nla_nest_start(msg, DEVLINK_ATTR_SELFTESTS_INFO);
> >+      if (!tests_info)
> >+              goto genlmsg_cancel;
> >+
> >+      for (i = 1; i < DEVLINK_SELFTEST_ATTR_MAX + 1; i++) {
>
> Same notes to the iteration as above. **
>
>
> >+              u8 res = DEVLINK_SELFTEST_SKIP;
>
> u8 test_status;
>
>
> >+
> >+              if (nla_get_flag(tb[i])) {
> >+                      if (devlink->ops->selftest_check &&
>
> No need to test in every iteration. I think it is safe to assume
> that driver that does not fill selftest_check() does not support
> selftests at all, so please move to the beginning of this function
> alongside selftest_run() check:
>
>         if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
>                 return -EOPNOTSUPP;
>
> >+                          !devlink->ops->selftest_check(devlink, i,
> >+                                                        info->extack)) {
> >+                              err = devlink_selftest_result_put(msg, i, res);
>
> Just do devlink_selftest_result_put(msg, i, .._SKIP); here and avoid
> initializing "res" at the beginning.
>
>
> >+                              if (err)
> >+                                      goto selftests_list_nest_cancel;
> >+                              continue;
> >+                      }
> >+
> >+                      res = devlink->ops->selftest_run(devlink, i,
> >+                                                       info->extack);
> >+                      err = devlink_selftest_result_put(msg, i, res);
> >+                      if (err)
> >+                              goto selftests_list_nest_cancel;
> >+              }
> >+      }
> >+
> >+      nla_nest_end(msg, tests_info);
> >+
>
> No need for this empty line.
>
>
> >+      genlmsg_end(msg, hdr);
> >+
>
> No need for this empty line.
>
>
> >+      return genlmsg_reply(msg, info);
> >+
> >+selftests_list_nest_cancel:
> >+      nla_nest_cancel(msg, tests_info);
> >+genlmsg_cancel:
> >+      genlmsg_cancel(msg, hdr);
> >+free_msg:
> >+      nlmsg_free(msg);
> >+      return err;
> >+}
> >+
> > static const struct devlink_param devlink_param_generic[] = {
> >       {
> >               .id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
> >@@ -8997,6 +9210,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> >       [DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> >       [DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> >       [DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
> >+      [DEVLINK_ATTR_SELFTESTS_INFO] = { .type = NLA_NESTED },
> > };
> >
> > static const struct genl_small_ops devlink_nl_ops[] = {
> >@@ -9356,6 +9570,17 @@ static const struct genl_small_ops devlink_nl_ops[] = {
> >               .doit = devlink_nl_cmd_trap_policer_set_doit,
> >               .flags = GENL_ADMIN_PERM,
> >       },
> >+      {
> >+              .cmd = DEVLINK_CMD_SELFTESTS_LIST,
> >+              .doit = devlink_nl_cmd_selftests_list_doit,
> >+              .dumpit = devlink_nl_cmd_selftests_list_dumpit
> >+              /* can be retrieved by unprivileged users */
> >+      },
> >+      {
> >+              .cmd = DEVLINK_CMD_SELFTESTS_RUN,
> >+              .doit = devlink_nl_cmd_selftests_run,
> >+              .flags = GENL_ADMIN_PERM,
> >+      },
> > };
> >
> > static struct genl_family devlink_nl_family __ro_after_init = {
> >--
> >2.31.1
> >
>
>

--0000000000008b8fb905e4541986
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHDjKB4nNrkqnspcqGj1U8RneUZLTCgzrOwK
4bg6XXP3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcyMTE3
MzIyMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQBqyB67gpEi5upMVx/WGCoeZhyr2SzwR99oGBQb8DSBtItJKWt6utNz
vzCcgq3OakB+sjJZXFEmOvlg4wjOnwZ73dGlQrb7HLHlw6BSK1pwFJ8MS2rUo2WyIUOkW9bCqGcZ
Auk/YuxfuLeN1AXor7gWYYPDW0xxSerXOdkU90xrMbu4N6gd1RcMOONhwdAw9SVP2s1oADScrzTc
dv2PsX9KuaEVMQcIP+hV+zGPaRY4wRHRM5aABC7fWWDcfLbajmJMIBQyMXd+asmz9JXjmOzl78er
nznxSuD66Lp28IbKVXw6B+Ay07ueemWbHSVx6kjCFPGp5Nx1L18CNyhy0jSf
--0000000000008b8fb905e4541986--
