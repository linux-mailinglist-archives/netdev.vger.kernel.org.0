Return-Path: <netdev+bounces-725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D486F9514
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 173EE1C21BDD
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C40111A5;
	Sat,  6 May 2023 23:30:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033981119F
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:30:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D5A59F1
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vDpom2RztN/03ErGZSbI4RmJgyW3xZZd2IBq9VSMG1g=;
	b=HKnsBalPkmx7e7ORIrPMT+vmpq4sgi5hWnjP6IOZBLtXEckMWxNz9/XfQ28f45r40XH8JR
	Xk14QNjRNOj2vst13pz+FHbUChavGuyLA585Y0VYjfmP1RxeVKrYtfVsMNKoEXswHhz0vL
	pbRVVlgSbJcCxZ07GVikbD/xnijnf8I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-KjmGpJ7KO0S6tdkt50H7SA-1; Sat, 06 May 2023 19:29:59 -0400
X-MC-Unique: KjmGpJ7KO0S6tdkt50H7SA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 054E8101A531;
	Sat,  6 May 2023 23:29:59 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 71A3635443;
	Sat,  6 May 2023 23:29:58 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH 08/11] iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
Date: Sat,  6 May 2023 16:29:27 -0700
Message-Id: <20230506232930.195451-9-cleech@redhat.com>
In-Reply-To: <20230506232930.195451-1-cleech@redhat.com>
References: <20230506232930.195451-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lee Duncan <lduncan@suse.com>

These are cleanups after the bus to class conversion
for flashnode devices.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/scsi/qla4xxx/ql4_os.c       |  52 +++++++-------
 drivers/scsi/scsi_transport_iscsi.c | 102 ++++++++++++++--------------
 include/scsi/scsi_transport_iscsi.h |  48 ++++++-------
 3 files changed, 102 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index bc06020565e4..bf5e2b3ce8ce 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -168,20 +168,20 @@ static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
  * iSCSI Flash DDB sysfs entry points
  */
 static int
-qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
-			    struct iscsi_bus_flash_conn *fnode_conn,
+qla4xxx_sysfs_ddb_set_param(struct iscsi_flash_session *fnode_sess,
+			    struct iscsi_flash_conn *fnode_conn,
 			    void *data, int len);
 static int
-qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
+qla4xxx_sysfs_ddb_get_param(struct iscsi_flash_session *fnode_sess,
 			    int param, char *buf);
 static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 				 int len);
 static int
-qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess);
-static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
-				   struct iscsi_bus_flash_conn *fnode_conn);
-static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn);
+qla4xxx_sysfs_ddb_delete(struct iscsi_flash_session *fnode_sess);
+static int qla4xxx_sysfs_ddb_login(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn);
+static int qla4xxx_sysfs_ddb_logout(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn);
 static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess);
 
 static struct qla4_8xxx_legacy_intr_set legacy_intr[] =
@@ -3494,8 +3494,8 @@ static int qla4xxx_task_xmit(struct iscsi_task *task)
 	return -ENOSYS;
 }
 
-static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
-					 struct iscsi_bus_flash_conn *conn,
+static int qla4xxx_copy_from_fwddb_param(struct iscsi_flash_session *sess,
+					 struct iscsi_flash_conn *conn,
 					 struct dev_db_entry *fw_ddb_entry)
 {
 	unsigned long options = 0;
@@ -3636,8 +3636,8 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	return rc;
 }
 
-static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
-				       struct iscsi_bus_flash_conn *conn,
+static int qla4xxx_copy_to_fwddb_param(struct iscsi_flash_session *sess,
+				       struct iscsi_flash_conn *conn,
 				       struct dev_db_entry *fw_ddb_entry)
 {
 	uint16_t options;
@@ -7183,7 +7183,7 @@ static void qla4xxx_build_new_nt_list(struct scsi_qla_host *ha,
  **/
 static int qla4xxx_sysfs_ddb_is_non_persistent(struct device *dev, void *data)
 {
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 
 	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
@@ -7213,8 +7213,8 @@ static int qla4xxx_sysfs_ddb_tgt_create(struct scsi_qla_host *ha,
 					struct dev_db_entry *fw_ddb_entry,
 					uint16_t *idx, int user)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
-	struct iscsi_bus_flash_conn *fnode_conn = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_conn *fnode_conn = NULL;
 	int rc = QLA_ERROR;
 
 	fnode_sess = iscsi_create_flashnode_sess(ha->host, *idx,
@@ -7353,8 +7353,8 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
  * This writes the contents of target ddb buffer to Flash with a valid cookie
  * value in order to make the ddb entry persistent.
  **/
-static int  qla4xxx_sysfs_ddb_apply(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn)
+static int  qla4xxx_sysfs_ddb_apply(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7543,8 +7543,8 @@ static int qla4xxx_ddb_login_nt(struct scsi_qla_host *ha,
  *
  * This logs in to the specified target
  **/
-static int qla4xxx_sysfs_ddb_login(struct iscsi_bus_flash_session *fnode_sess,
-				   struct iscsi_bus_flash_conn *fnode_conn)
+static int qla4xxx_sysfs_ddb_login(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7727,8 +7727,8 @@ static int qla4xxx_sysfs_ddb_logout_sid(struct iscsi_cls_session *cls_sess)
  *
  * This performs log out from the specified target
  **/
-static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn)
+static int qla4xxx_sysfs_ddb_logout(struct iscsi_flash_session *fnode_sess,
+				    struct iscsi_flash_conn *fnode_conn)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
@@ -7837,12 +7837,12 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 }
 
 static int
-qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
+qla4xxx_sysfs_ddb_get_param(struct iscsi_flash_session *fnode_sess,
 			    int param, char *buf)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_conn *fnode_conn;
 	struct ql4_chap_table chap_tbl;
 	struct device *dev;
 	int parent_type;
@@ -8091,8 +8091,8 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
  * This sets the parameter of flash ddb entry and writes them to flash
  **/
 static int
-qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
-			    struct iscsi_bus_flash_conn *fnode_conn,
+qla4xxx_sysfs_ddb_set_param(struct iscsi_flash_session *fnode_sess,
+			    struct iscsi_flash_conn *fnode_conn,
 			    void *data, int len)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
@@ -8319,7 +8319,7 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
  *
  * This invalidates the flash ddb entry at the given index
  **/
-static int qla4xxx_sysfs_ddb_delete(struct iscsi_bus_flash_session *fnode_sess)
+static int qla4xxx_sysfs_ddb_delete(struct iscsi_flash_session *fnode_sess)
 {
 	struct Scsi_Host *shost = iscsi_flash_session_to_shost(fnode_sess);
 	struct scsi_qla_host *ha = to_qla_host(shost);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2fae14aa291e..26b3d479b6ac 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -875,7 +875,7 @@ static ssize_t								\
 show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 		     char *buf)						\
 {									\
-	struct iscsi_bus_flash_session *fnode_sess =			\
+	struct iscsi_flash_session *fnode_sess =			\
 					iscsi_dev_to_flash_session(dev);\
 	struct iscsi_transport *t = fnode_sess->transport;		\
 	return t->get_flashnode_param(fnode_sess, param, buf);		\
@@ -975,7 +975,7 @@ static umode_t iscsi_flashnode_sess_attr_is_visible(struct kobject *kobj,
 						    int i)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct iscsi_bus_flash_session *fnode_sess =
+	struct iscsi_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 	struct iscsi_transport *t = fnode_sess->transport;
 	int param;
@@ -1066,7 +1066,7 @@ static const struct attribute_group *iscsi_flashnode_sess_attr_groups[] = {
 
 static void iscsi_flashnode_sess_release(struct device *dev)
 {
-	struct iscsi_bus_flash_session *fnode_sess =
+	struct iscsi_flash_session *fnode_sess =
 						iscsi_dev_to_flash_session(dev);
 
 	kfree(fnode_sess->targetname);
@@ -1076,7 +1076,7 @@ static void iscsi_flashnode_sess_release(struct device *dev)
 }
 
 static const struct device_type iscsi_flashnode_sess_dev_type = {
-	.name = "iscsi_flashnode_sess_dev_type",
+	.name = "iscsi_flashnode_sess",
 	.groups = iscsi_flashnode_sess_attr_groups,
 	.release = iscsi_flashnode_sess_release,
 };
@@ -1093,8 +1093,8 @@ static ssize_t								\
 show_##type##_##name(struct device *dev, struct device_attribute *attr,	\
 		     char *buf)						\
 {									\
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);\
-	struct iscsi_bus_flash_session *fnode_sess =			\
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);\
+	struct iscsi_flash_session *fnode_sess =			\
 				iscsi_flash_conn_to_flash_session(fnode_conn);\
 	struct iscsi_transport *t = fnode_conn->transport;		\
 	return t->get_flashnode_param(fnode_sess, param, buf);		\
@@ -1183,7 +1183,7 @@ static umode_t iscsi_flashnode_conn_attr_is_visible(struct kobject *kobj,
 						    int i)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 	struct iscsi_transport *t = fnode_conn->transport;
 	int param;
 
@@ -1259,7 +1259,7 @@ static const struct attribute_group *iscsi_flashnode_conn_attr_groups[] = {
 
 static void iscsi_flashnode_conn_release(struct device *dev)
 {
-	struct iscsi_bus_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
+	struct iscsi_flash_conn *fnode_conn = iscsi_dev_to_flash_conn(dev);
 
 	kfree(fnode_conn->ipaddress);
 	kfree(fnode_conn->redirect_ipaddr);
@@ -1268,12 +1268,28 @@ static void iscsi_flashnode_conn_release(struct device *dev)
 }
 
 static const struct device_type iscsi_flashnode_conn_dev_type = {
-	.name = "iscsi_flashnode_conn_dev_type",
+	.name = "iscsi_flashnode_conn",
 	.groups = iscsi_flashnode_conn_attr_groups,
 	.release = iscsi_flashnode_conn_release,
 };
 
-static struct class iscsi_flashnode_bus = {
+/**
+ * iscsi_is_flashnode_conn_dev - verify passed device is to be flashnode conn
+ * @dev: device to verify
+ * @data: pointer to data containing value to use for verification
+ *
+ * Verifies if the passed device is flashnode conn device
+ *
+ * Returns:
+ *  1 on success
+ *  0 on failure
+ */
+static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
+{
+	return dev->type == &iscsi_flashnode_conn_dev_type;
+}
+
+static struct class iscsi_flashnode = {
 	.name = "iscsi_flashnode",
 };
 
@@ -1290,12 +1306,12 @@ static struct class iscsi_flashnode_bus = {
  *  pointer to allocated flashnode sess on success
  *  %NULL on failure
  */
-struct iscsi_bus_flash_session *
+struct iscsi_flash_session *
 iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 			    struct iscsi_transport *transport,
 			    int dd_size)
 {
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 	int err;
 
 	fnode_sess = kzalloc(sizeof(*fnode_sess) + dd_size, GFP_KERNEL);
@@ -1305,7 +1321,7 @@ iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 	fnode_sess->transport = transport;
 	fnode_sess->target_id = index;
 	fnode_sess->dev.type = &iscsi_flashnode_sess_dev_type;
-	fnode_sess->dev.class = &iscsi_flashnode_bus;
+	fnode_sess->dev.class = &iscsi_flashnode;
 	fnode_sess->dev.parent = &shost->shost_gendev;
 	dev_set_name(&fnode_sess->dev, "flashnode_sess-%u:%u",
 		     shost->host_no, index);
@@ -1338,13 +1354,13 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_sess);
  *  pointer to allocated flashnode conn on success
  *  %NULL on failure
  */
-struct iscsi_bus_flash_conn *
+struct iscsi_flash_conn *
 iscsi_create_flashnode_conn(struct Scsi_Host *shost,
-			    struct iscsi_bus_flash_session *fnode_sess,
+			    struct iscsi_flash_session *fnode_sess,
 			    struct iscsi_transport *transport,
 			    int dd_size)
 {
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_conn *fnode_conn;
 	int err;
 
 	fnode_conn = kzalloc(sizeof(*fnode_conn) + dd_size, GFP_KERNEL);
@@ -1353,7 +1369,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 
 	fnode_conn->transport = transport;
 	fnode_conn->dev.type = &iscsi_flashnode_conn_dev_type;
-	fnode_conn->dev.class = &iscsi_flashnode_bus;
+	fnode_conn->dev.class = &iscsi_flashnode;
 	fnode_conn->dev.parent = &fnode_sess->dev;
 	dev_set_name(&fnode_conn->dev, "flashnode_conn-%u:%u:0",
 		     shost->host_no, fnode_sess->target_id);
@@ -1373,23 +1389,7 @@ iscsi_create_flashnode_conn(struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
 
-/**
- * iscsi_is_flashnode_conn_dev - verify passed device is to be flashnode conn
- * @dev: device to verify
- * @data: pointer to data containing value to use for verification
- *
- * Verifies if the passed device is flashnode conn device
- *
- * Returns:
- *  1 on success
- *  0 on failure
- */
-static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
-{
-	return dev->type == &iscsi_flashnode_conn_dev_type;
-}
-
-static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
+static int iscsi_destroy_flashnode_conn(struct iscsi_flash_conn *fnode_conn)
 {
 	device_unregister(&fnode_conn->dev);
 	return 0;
@@ -1397,10 +1397,10 @@ static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
 
 static int flashnode_match_index(struct device *dev, void *data)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
 	int ret = 0;
 
-	if (dev->type != &iscsi_flashnode_sess_dev_type)
+	if (!iscsi_is_flashnode_session_dev(dev))
 		goto exit_match_index;
 
 	fnode_sess = iscsi_dev_to_flash_session(dev);
@@ -1421,10 +1421,10 @@ static int flashnode_match_index(struct device *dev, void *data)
  *  pointer to found flashnode session object on success
  *  %NULL on failure
  */
-static struct iscsi_bus_flash_session *
+static struct iscsi_flash_session *
 iscsi_get_flashnode_by_index(struct Scsi_Host *shost, uint32_t idx)
 {
-	struct iscsi_bus_flash_session *fnode_sess = NULL;
+	struct iscsi_flash_session *fnode_sess = NULL;
 	struct device *dev;
 
 	dev = device_find_child(&shost->shost_gendev, &idx,
@@ -1468,7 +1468,7 @@ EXPORT_SYMBOL_GPL(iscsi_find_flashnode_sess);
  *  %NULL on failure
  */
 struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess)
+iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess)
 {
 	return device_find_child(&fnode_sess->dev, NULL,
 				 iscsi_is_flashnode_conn_dev);
@@ -1490,7 +1490,7 @@ static int iscsi_iter_destroy_flashnode_conn_fn(struct device *dev, void *data)
  * Deletes the flashnode session entry and all children flashnode connection
  * entries from sysfs
  */
-void iscsi_destroy_flashnode_sess(struct iscsi_bus_flash_session *fnode_sess)
+void iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess)
 {
 	int err;
 
@@ -1506,7 +1506,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_flashnode_sess);
 
 static int iscsi_iter_destroy_flashnode_fn(struct device *dev, void *data)
 {
-	if (dev->type != &iscsi_flashnode_sess_dev_type)
+	if (!iscsi_is_flashnode_session_dev(dev))
 		return 0;
 
 	iscsi_destroy_flashnode_sess(iscsi_dev_to_flash_session(dev));
@@ -3644,8 +3644,8 @@ static int iscsi_set_flashnode_param(struct net *net,
 {
 	char *data = (char *)ev + sizeof(*ev);
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -3733,7 +3733,7 @@ static int iscsi_del_flashnode(struct net *net,
 			       struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
+	struct iscsi_flash_session *fnode_sess;
 	uint32_t idx;
 	int err = 0;
 
@@ -3774,8 +3774,8 @@ static int iscsi_login_flashnode(struct net *net,
 				 struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -3827,8 +3827,8 @@ static int iscsi_logout_flashnode(struct net *net,
 				  struct iscsi_uevent *ev)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_bus_flash_session *fnode_sess;
-	struct iscsi_bus_flash_conn *fnode_conn;
+	struct iscsi_flash_session *fnode_sess;
+	struct iscsi_flash_conn *fnode_conn;
 	struct device *dev;
 	uint32_t idx;
 	int err = 0;
@@ -5229,7 +5229,7 @@ static __init int iscsi_transport_init(void)
 	if (err)
 		goto unregister_conn_class;
 
-	err = class_register(&iscsi_flashnode_bus);
+	err = class_register(&iscsi_flashnode);
 	if (err)
 		goto unregister_session_class;
 
@@ -5252,7 +5252,7 @@ static __init int iscsi_transport_init(void)
 unregister_pernet_subsys:
 	unregister_pernet_subsys(&iscsi_net_ops);
 unregister_flashnode_bus:
-	class_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -5272,7 +5272,7 @@ static void __exit iscsi_transport_exit(void)
 {
 	destroy_workqueue(iscsi_conn_cleanup_workq);
 	unregister_pernet_subsys(&iscsi_net_ops);
-	class_unregister(&iscsi_flashnode_bus);
+	class_unregister(&iscsi_flashnode);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
 	transport_class_unregister(&iscsi_host_class);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f9d003753f11..a23b511b6f53 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -26,8 +26,8 @@ struct iscsi_task;
 struct sockaddr;
 struct iscsi_iface;
 struct bsg_job;
-struct iscsi_bus_flash_session;
-struct iscsi_bus_flash_conn;
+struct iscsi_flash_session;
+struct iscsi_flash_conn;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -149,18 +149,18 @@ struct iscsi_transport {
 			 uint32_t *num_entries, char *buf);
 	int (*delete_chap) (struct Scsi_Host *shost, uint16_t chap_tbl_idx);
 	int (*set_chap) (struct Scsi_Host *shost, void *data, int len);
-	int (*get_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
-				    int param, char *buf);
-	int (*set_flashnode_param) (struct iscsi_bus_flash_session *fnode_sess,
-				    struct iscsi_bus_flash_conn *fnode_conn,
-				    void *data, int len);
-	int (*new_flashnode) (struct Scsi_Host *shost, const char *buf,
-			      int len);
-	int (*del_flashnode) (struct iscsi_bus_flash_session *fnode_sess);
-	int (*login_flashnode) (struct iscsi_bus_flash_session *fnode_sess,
-				struct iscsi_bus_flash_conn *fnode_conn);
-	int (*logout_flashnode) (struct iscsi_bus_flash_session *fnode_sess,
-				 struct iscsi_bus_flash_conn *fnode_conn);
+	int (*get_flashnode_param)(struct iscsi_flash_session *fnode_sess,
+				   int param, char *buf);
+	int (*set_flashnode_param)(struct iscsi_flash_session *fnode_sess,
+				   struct iscsi_flash_conn *fnode_conn,
+				   void *data, int len);
+	int (*new_flashnode)(struct Scsi_Host *shost, const char *buf,
+			     int len);
+	int (*del_flashnode)(struct iscsi_flash_session *fnode_sess);
+	int (*login_flashnode)(struct iscsi_flash_session *fnode_sess,
+			       struct iscsi_flash_conn *fnode_conn);
+	int (*logout_flashnode)(struct iscsi_flash_session *fnode_sess,
+				struct iscsi_flash_conn *fnode_conn);
 	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
 	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
 	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
@@ -342,7 +342,7 @@ struct iscsi_iface {
 	dev_to_shost(_iface->dev.parent)
 
 
-struct iscsi_bus_flash_conn {
+struct iscsi_flash_conn {
 	struct list_head conn_list;	/* item in connlist */
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
@@ -380,14 +380,14 @@ struct iscsi_bus_flash_conn {
 };
 
 #define iscsi_dev_to_flash_conn(_dev) \
-	container_of(_dev, struct iscsi_bus_flash_conn, dev)
+	container_of(_dev, struct iscsi_flash_conn, dev)
 
 #define iscsi_flash_conn_to_flash_session(_conn) \
 	iscsi_dev_to_flash_session(_conn->dev.parent)
 
 #define ISID_SIZE 6
 
-struct iscsi_bus_flash_session {
+struct iscsi_flash_session {
 	struct list_head sess_list;		/* item in session_list */
 	struct iscsi_transport *transport;
 	unsigned int target_id;
@@ -442,7 +442,7 @@ struct iscsi_bus_flash_session {
 };
 
 #define iscsi_dev_to_flash_session(_dev) \
-	container_of(_dev, struct iscsi_bus_flash_session, dev)
+	container_of(_dev, struct iscsi_flash_session, dev)
 
 #define iscsi_flash_session_to_shost(_session) \
 	dev_to_shost(_session->dev.parent)
@@ -503,17 +503,17 @@ extern struct device *
 iscsi_find_flashnode(struct Scsi_Host *shost, void *data,
 		     int (*fn)(struct device *dev, void *data));
 
-extern struct iscsi_bus_flash_session *
+extern struct iscsi_flash_session *
 iscsi_create_flashnode_sess(struct Scsi_Host *shost, int index,
 			    struct iscsi_transport *transport, int dd_size);
 
-extern struct iscsi_bus_flash_conn *
+extern struct iscsi_flash_conn *
 iscsi_create_flashnode_conn(struct Scsi_Host *shost,
-			    struct iscsi_bus_flash_session *fnode_sess,
+			    struct iscsi_flash_session *fnode_sess,
 			    struct iscsi_transport *transport, int dd_size);
 
 extern void
-iscsi_destroy_flashnode_sess(struct iscsi_bus_flash_session *fnode_sess);
+iscsi_destroy_flashnode_sess(struct iscsi_flash_session *fnode_sess);
 
 extern void iscsi_destroy_all_flashnode(struct Scsi_Host *shost);
 extern int iscsi_flashnode_bus_match(struct device *dev,
@@ -522,7 +522,9 @@ extern struct device *
 iscsi_find_flashnode_sess(struct Scsi_Host *shost, void *data,
 			  int (*fn)(struct device *dev, void *data));
 extern struct device *
-iscsi_find_flashnode_conn(struct iscsi_bus_flash_session *fnode_sess);
+iscsi_find_flashnode_conn(struct iscsi_flash_session *fnode_sess);
+
+extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
 extern bool iscsi_is_flashnode_session_dev(struct device *dev);
 
-- 
2.39.2


